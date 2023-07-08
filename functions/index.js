const functions = require("firebase-functions");
const admin = require("firebase-admin")
admin.initializeApp();
const firestore = admin.firestore();
const messaging = admin.messaging();
const fieldValue = admin.firestore.FieldValue;
const { stringify } = require("querystring");
const stripe = require("stripe")("sk_test_51JlprhDNcCglceqdJau2DmlvpDI5IZsYo1G62Kt2j94QFplJPqKvBu6CXVFyRxhGmAvkTfZWMfq4LxeiN8qHQTQx00R06yr8RM");
const axios = require('axios');
//payment work:
exports.createIntentPayment = functions.https.onRequest(async(req, res) => {
    try {

        var customerId = req.body.customerId;
        var amount = req.body.amount;
        // let customer;
        // //Gets the customer who's email id matches the one sent by the client
        // const customerList = await stripe.customers.list({
        //     email: req.body.email,
        //     limit: 1
        // });

        // //Checks the if the customer exists, if not creates a new customer
        // if (customerList.data.length !== 0) {
        //     customerId = customerList.data[0].id;
        //     customer = customerList.data[0];
        // } else {
        //     const customer = await stripe.customers.create({
        //         email: req.body.email
        //     });
        //     customerId = customer.data.id;
        //     customer = customer.data;
        // }



        // const mode = 'setup';
        // const success_url = "https://www.success.com";
        // const cancel_url = "https://www.cancel.com";
        // var metadata = {};
        // var billing_address_collection = 'required';
        // var locale = 'auto';
        // var customer_update = {};
        // var after_expiration = {};
        // var consent_collection = {};
        // const expires_at = "1661624965";
        // var trial_from_plan = true;
        // var phone_number_collection = {}
        // var automatic_payment_methods = { enabled: true };
        // var payment_method_types = ["card"];
        // customer = customerId;
        // current_period_start = "1698431365";
        // current_period_end = "1701109765";

        // const sessionCreateParams = Object.assign({

        //     customer,
        //     customer_update,
        //     // line_items: [{ price: 'price_1LNg3FDNcCglceqdE7juBY8W', quantity: 1 }, ],
        //     mode,
        //     current_period_start,
        //     current_period_end,
        //     success_url,
        //     cancel_url,
        //     locale,
        //     after_expiration,
        //     consent_collection,
        //     payment_method_types,
        //     phone_number_collection
        // }, (expires_at && { expires_at }));
        // // sessionCreateParams.subscription_data = {
        // //     trial_from_plan,
        // //     metadata,
        // // };
        // const session = await stripe.checkout.sessions.create(sessionCreateParams, { idempotencyKey: 645321 });
        // const schedule = await stripe.subscriptionSchedules.create({
        //     customer: customerId,
        //     start_date: new Date("2023-09-01").getTime() / 1000,
        //     end_behavior: 'release',



        //     phases: [{
        //             items: [
        //                 { price: 'price_1LNg3FDNcCglceqdE7juBY8W', quantity: 1 },
        //             ],
        //             iterations: 1,
        //         },

        //     ],

        // });
        // console.log(JSON.stringify(schedule));
        // console.log(JSON.stringify(session));

        // Creates a temporary secret key linked with the customer
        const ephemeralKey = await stripe.ephemeralKeys.create({ customer: customerId }, { apiVersion: '2020-08-27' });

        //Creates a new payment intent with amount passed in from the client
        const paymentIntent = await stripe.paymentIntents.create({
            amount: parseInt(amount),
            currency: 'USD',
            setup_future_usage: 'off_session',
            customer: customerId,
        })

        res.status(200).send({
            paymentIntent: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customerId,
            success: true,
        })


    } catch (error) {
        console.info(JSON.stringify(error));
        res.status(404).send({ success: false, error: error.message })
    }
});

//calls when user doesnt have any stripe account created.
exports.fillStripeDetailsToUserDocument = functions.https.onRequest(async(req, res) => {
    try {


        var email = req.body.email;
        var userId = req.body.userId;

        console.log("userId: " + userId + " email: " + email);
        const customerList = await stripe.customers.list({
            email: email,
            limit: 1
        });
        //Checks the if the customer exists, if not creates a new customer
        if (customerList.data.length !== 0) {
            var customerId = customerList.data[0].id;
            await firestore.collection('users').doc(userId).set({ "stripeId": customerId.toString() }, { merge: true });
            res.status(200).send({ "success": "Updated..." });
        }

        res.status(200).send({ "success": "Email doesnt exist...." })
    } catch (error) {
        console.info(JSON.stringify(error));
        res.status(404).send({ success: false, error: error.message })
    }
})



//starts subscription with priceId, startDate, and customerId.
exports.startSubscription = functions.https.onRequest(async(req, res) => {

    var customerId = req.body.customerId;
    var priceId = req.body.priceId;
    var start_date = req.body.start_date;
    try {
        const schedule = await stripe.subscriptionSchedules.create({
            customer: customerId,
            start_date: start_date,
            end_behavior: 'cancel',

            phases: [{
                    items: [
                        { price: priceId, quantity: 1 },
                    ],
                    iterations: 1,
                },

            ],

        });
        console.log(JSON.stringify(schedule));
        res.status(200).send(schedule);

    } catch (e) {
        console.error(e);
        res.status(404).send({ success: false, error: e.message })
    }
})


//function to run daily to see if user is expired.. [important function].
exports.scheduleUserExpirationDaily = functions.runWith({ timeoutSeconds: 540, memory: "1GB" })
    .pubsub.schedule("0 0 * * *").onRun(
        async(context) => {
            try {
                console.log('scheduleUserExpirationDaily started');
                const snapshot = await firestore.collection('users').get();
                console.log("✓✓ Total users to check today: ", snapshot.size)

                for (const doc of snapshot.docs) {

                    try {
                        var userData = doc.data();
                        //skip all those that are already expired.
                        if (userData.isSubscriptionExpired != true) {
                            console.info("===========> FOR ID " + userData.userId + "<===========");
                            //IF INVITED BY GUARDIAN THEN IT MEANS THEIR SUBSCRIPTION DATA IS IN THEIR DOC...
                            if (userData.guardianPaymentPath != undefined) {
                                console.info("****================> IF CASE <============================****");
                                var arr = userData.guardianPaymentPath.split('/');
                                //MAKING PATH TO REACH GUARDIAN DOC ID.
                                var detail = await firestore.collection(arr[0]).doc(arr[1]).collection(arr[2] + "s").doc(arr[3]).get();
                                var subcriptionData = detail.data();
                                if (subcriptionData != undefined && subcriptionData.status != "active") {
                                    ///ENDING SUBSCRIPTION HERE IF STATUS IS NOT ACTIVE..
                                    console.log("😱😱😱 Subscription ended for user => " + userData.userId + " because status is " + subcriptionData.status);
                                    await firestore.collection("users").doc(userData.userId).set({
                                        "isSubscriptionExpired": true
                                    }, { merge: true });

                                }
                            } else {
                                console.info("****================> ELSE CASE <============================*****");
                                //For Account itself subscription
                                var subscriptions = await firestore.collection("users").doc(userData.userId).collection("subscriptions").get();



                                let subscriptionStatus = "expired";
                                //checking if any of status is active then it means its perfect.
                                for (const subscription of subscriptions.docs) {
                                    var subscriptionData = subscription.data();
                                    console.log(subscriptionData.status);

                                    //meta data check is for to avoid subscription from others as if meta data is not null that means he have bought that specific subscription for someone else and not for himself so avoiding that.
                                    if (subscriptionData.status != undefined && subscriptionData.status == "active" && subscriptionData.metadata == "" || subscriptionData.metadata == undefined) {
                                        subscriptionStatus = "active";
                                    }
                                }

                                console.log("IMP PLACE>>>>" + subscriptionStatus);
                                if (subscriptionStatus != "active" && subscriptionData != undefined) {
                                    ///ENDING SUBSCRIPTION HERE IF STATUS IS NOT ACTIVE..
                                    console.log("😱😱😱 else case for Subscription ended for user => " + userData.userId + " because status is " + subscriptionData.status);
                                    await firestore.collection("users").doc(userData.userId).set({
                                        "isSubscriptionExpired": true
                                    }, { merge: true });

                                }
                            }
                        } else {
                            console.log("skipped because status is true ", userData.userId);
                        }

                    } catch (e) {
                        console.log("Error catched success");
                        console.error(e);

                    }
                }

            } catch (e) {
                console.log("Exception in Schedule User docs");
                console.error(e);


            }


            console.log('Schedule User ended');
        })



exports.onEmergencyContactAdded = functions.firestore.document('users/{userId}/emergencyContacts/{docId}').onCreate(async(snapshot, ctx) => {
    console.info("******************HITTING FOR onEmergencyContactAdded " + ctx.params.userId + " ************************");
    const documentData = snapshot.data();
    var userRef = firestore.collection('users');
    // var userData = (await userRef.get()).data();
    const phoneNumberToSearch = documentData.phoneNumber.toString().replace("+", "").trim();
    try {
        var matchedUsers = await userRef.where("phone", "==", "+" + phoneNumberToSearch).get();
        console.log();
        if (matchedUsers.empty) {
            console.log("Notihing found against the " + phoneNumberToSearch + " number");
            return;
        }


        matchedUsers.forEach(user => {
            snapshot.ref.update({
                "userId": user.id
            }, { merge: true });

        });

    } catch (e) {
        console.error("❗ errrrrr", e);
    }



});

exports.OnAlertButtonPressed = functions.firestore.document('emergency/{userId}').onCreate(async(snapshot, ctx) => {
    console.info("******************HITTING ONPRESSED FOR" + ctx.params.userId + "************************");
    const documentData = snapshot.data();
    var userRef = firestore.collection('users').doc(ctx.params.userId);
    var emergencyContactsData = await firestore.collection('users').doc(ctx.params.userId).collection('emergencyContacts').get();
    var userData = (await userRef.get()).data();
    try {
        sendNotificationToEmployee("Emergency Alert ❗", userData.name + " is in need of emergency help❗❗❗. Coordinates are Latitude: " + documentData.lat + " Longitude: " + documentData.lng);

        if (emergencyContactsData.empty) {
            console.log('No emergencyContactsData clsoing here...');
            return;
        }

        emergencyContactsData.forEach(async contact => {

            await sendMessageToUser(contact.data().phoneNumber, userData.name + " is in need of emergency help❗❗❗. Coordinates are Latitude: " + documentData.lat + " Longitude: " + documentData.lng + ". This Message is sent from Medical Emergency Application.");
            if (contact.data().userId != undefined) {
                await sendNotification(contact.data().userId, "Emergency Alert ❗", userData.name + " is in need of emergency help❗❗❗. Coordinates are Latitude: " + documentData.lat + " Longitude: " + documentData.lng);
            } else {
                console.log("no user id for sending noti from Alert Button...")
            }
        });
    } catch (e) {
        console.error("❗ errrrrr", e);
        sendNotificationToEmployee("Emergency Alert ❗", userData.name + " is in need of emergency help❗❗❗. Coordinates are Latitude: " + documentData.lat + " Longitude: " + documentData.lng);

    }



});



exports.sniffUserCollection = functions.firestore.document('users/{userId}').onCreate(async(snapshot, ctx) => {
    console.info("******************HITTING FOR" + ctx.params.userId + "************************");
    var userRef = firestore.collection('users').doc(ctx.params.userId);
    const newUser = snapshot.data();
    try {

        if (newUser.guardianId != undefined) {
            firestore.collection('users').doc(newUser.guardianId).collection("subscriptions").where("metadata.number", '==', "+" + newUser.phone).get().then(async snap => {
                if (snap.docs.length == 0) {
                    console.warn("❗ I didnt found subscription in guardian id....❗ " + "for this number" + newUser.phone + "    ", ctx.params.userId);
                }
                await userRef.set({

                    "guardianPaymentPath": "users/" + newUser.guardianId + "/subscription/" + snap.docs[0].id
                }, { merge: true });
                console.info("🚦 🚦 🚦 🚦 Succesfully Updated Subscription user to new user...🚦 🚦 🚦 🚦 ", ctx.params.userId);

            });
        } else {
            console.warn("❗ No guardian id is founded in:", ctx.params.userId);
        }
    } catch (e) {
        console.error("❗ errrrrr", e);
    }



});



exports.paymentsDocument = functions.firestore.document('users/{userId}/payments/{paymentId}')
    .onCreate(async(snapshot, context) => {
        console.log("TRIGGER ON paymentsDocument", );
        var document = snapshot.data();
        console.log("Snapshot=>: ", JSON.stringify(document));
        var userRef = firestore.collection('users').doc(context.params.userId);
        userRef.collection('checkout_sessions').where('paymentIntentClientSecret', '==', document.client_secret).get()
            .then(snapshot => {
                userRef.collection('checkout_sessions').doc(snapshot.docs[0].id).set({
                    "isSuccess": true,
                }, { merge: true });
            })
            .catch(err => {

            });

    });
//     );

exports.onPaymentSuccess = functions.firestore.document('users/{userId}/checkout_sessions/{checkout_sessionId}')
    .onUpdate(async(snapshot, context) => {
            console.log("TRIGGER ON PAYMENT SUCCESS", );
            var document = snapshot.after.data();
            console.log("Snapshot=>: ", JSON.stringify(document));
            var userRef = firestore.collection('users').doc(context.params.userId);
            ///Payment has been paid!!!
            if (document.isSuccess == true) {
                await sendNotification(context.params.userId, "Payment Success", "You've paid successfully for " + document.toNumber);
                if (document.toNumber != undefined) {
                    sendMessageToUser(document.toNumber, userRef.name + " has invited you to Medical Emergency App to help you in case of emergency.", );

                } else {
                    console.log("No number");
                }

            } else {
                // await sendNotification(context.params.userId, "Payment Success", "You've paid successfully for " + document.toNumber);
                console.log("else case for snapshot.isSuccess == true");
            }

        }

    );


/**
 * Employee Work starts
 */

//for employee when admin change status to paid that means admin have paid now increament the value.
// exports.onCallLogUpdated = functions.firestore.document('employeeLogs/{empId}/logs/{logsId}')
exports.onCallLogUpdated = functions.firestore.document('employeeLogs/{logsId}')
    .onUpdate(async(snapshot, context) => {
        var document = snapshot.after.data();
        if (document.status == "Paid") {
            console.log("context empID", context.params.empId);
            try {
                const empId = document.uid;

                firestore.collection('employee').doc(empId).collection("wallet").doc("payments").set({
                    amount: fieldValue.increment(5),
                    pending: fieldValue.increment(-5),
                }, { merge: true });
                firestore.collection('employee').doc(empId).collection("paymentsHistory").doc(document.id).set({
                    document,
                    "message": "Payment succesfully paid!"
                }, { merge: true });
            } catch (e) {
                firestore.collection("crash_logs").doc(context.params.empId).collection("payments").doc(document.id).set({
                    "document": document,
                    "error": e
                });


            }
        } else if (document.status == "Rejected") {
            firestore.collection('employee').doc(empId).collection("wallet").doc("payments").set({
                pending: fieldValue.increment(-5),
            }, { merge: true });
            firestore.collection('employee').doc(empId).collection("paymentsHistory").doc(document.id).set({
                document,
                "message": "Your screenshot has been rejected. No payout for this."

            }, { merge: true });
        }

    })


// exports.onCallLogCreated = functions.firestore.document('employeeLogs/{empId}/logs/{logsId}')
exports.onCallLogCreated = functions.firestore.document('employeeLogs/{logsId}')
    .onCreate(async(snapshot, context) => {
        try {
            var document = snapshot.data();
            const empId = document.uid;
            await firestore.collection('employee').doc(empId).collection("wallet").doc("payments").set({
                pending: fieldValue.increment(5)
            }, { merge: true });

        } catch (e) {
            console.log(e);
        }

    });

exports.onCreateNewEmployee = functions.firestore.document('employee/{empId}').onCreate(async(snapshot, ctx) => {
    console.info("******************HITTING FOR" + ctx.params.empId + "************************");
    try {
        firestore.collection('employee').doc(ctx.params.empId).collection("wallet").doc("payments").set({
            "Pending": 0,
            "TotalEarning": 0,
        });
    } catch (e) {}
});


/**
 * Notifications and Dummy work below
 */

//dummy
exports.dummySendNotifi = functions.https.onRequest(async(req, res) => {


    try {
        await sendTestNotificationToEmployee("h", " ahaha ahha ahaha")

        res.status(200).send("sent");

    } catch (e) {
        console.error(e);
        res.status(404).send({ success: false, error: e.message })
    }
})

const sendTestNotificationToEmployee = async(title, message) => {
    console.log("SENDING NOTIIIS TO EMPLOYE");
    try {
        var userRef = firestore.collection('employee_tokens').get();



        (await userRef).docs.forEach(async(emp) => {
            console.log("data => ", emp.data())
            var userData = emp.data();
            const token = await userData.token
            const isEmployeeActive = await userData.isActive
                //     const tokens = tokenSnapshot.docs.map(snap => snap.id);
            if (token != null && isEmployeeActive == true) {
                await messaging.send({
                    data: {
                        "fake": "a",
                    },
                    tokens: [token],
                    notification: {
                        title: title,
                        body: message
                    },
                    // data: "fake",

                    android: {
                        notification: {
                            title: title,
                            body: message,
                            sound: "default"
                        }
                    },
                    apns: {
                        payload: {
                            aps: {
                                sound: "default"
                            }
                        }
                    },


                }).then(() => {
                    console.log("✓✓✓✓✓✓✓✓✓✓✓ Successfully sent noti to " + userId);
                })
            } else {
                console.log("Noti failed to sent to becuase no token found...");
            }
        })
    } catch (e) {
        console.log("below error catched");
        console.log(JSON.stringify(e));
    }


}

function sendMessageToUser(phoneNumber, message) {
    try {
        console.log("SENDING MESSAGE TO USER", phoneNumber, message);
        return admin.firestore().collection("messages")
            .add({
                to: phoneNumber,
                body: message,
            });
    } catch (e) {
        console.error("Error in sending message to user" + phoneNumber);
    }

}


const sendNotificationToEmployee = async(title, message) => {
    console.log("SENDING NOTIIIS TO EMPLOYE");
    try {
        var userRef = firestore.collection('employee_tokens').get();
        (await userRef).docs.forEach(async(emp) => {

            var userData = emp.data();
            const token = await userData.token
            const isEmployeeActive = await userData.isActive
                //     const tokens = tokenSnapshot.docs.map(snap => snap.id);
            if (token != null && isEmployeeActive == true) {
                messaging.sendMulticast({
                    tokens: [token],
                    notification: {
                        title: title,
                        body: message
                    },
                    android: {
                        notification: {
                            title: title,
                            body: message,
                            sound: "default"
                        }
                    },
                    apns: {
                        payload: {
                            aps: {
                                sound: "default"
                            }
                        }
                    }

                }).then(() => {
                    console.log("✓✓✓✓✓✓✓✓✓✓✓ Successfully sent noti to " + userId);
                })
            } else {
                console.log("Noti failed to sent to becuase no token found..." + userId);
            }
        })
    } catch (e) {
        console.log("below error catched");
        console.log(JSON.stringify(e));
    }


}
const sendNotification = async(userId, title, message) => {
    console.log("Sending noti to " + userId);
    var userRef = firestore.collection('users').doc(userId);
    var userData = (await userRef.get()).data();
    const token = await userData.token
        //     const tokens = tokenSnapshot.docs.map(snap => snap.id);
    if (token != null) {
        messaging.sendMulticast({
            tokens: [token],
            notification: {
                title: title,
                body: message
            },
            android: {
                notification: {
                    title: title,
                    body: message,
                    sound: "default"
                }
            },
            apns: {
                payload: {
                    aps: {
                        sound: "default"
                    }
                }
            }

        }).then(() => {
            print("✓✓✓✓✓✓✓✓✓✓✓ Successfully sent noti to " + userId);
        })
    } else {
        console.log("Noti failed to sent to becuase no token found..." + userId);
    }
}

const sendNotificationToToken = async(tokens, title, message) => {
    // var userRef = firestore.collection('users').doc(userId);
    // var userData = (await userRef.get()).data();
    // const token = await userData.token
    //     const tokens = tokenSnapshot.docs.map(snap => snap.id);
    if (tokens != null) {
        messaging.sendMulticast({
            tokens: tokens,
            notification: {
                title: title,
                body: message
            },
            android: {
                notification: {
                    title: title,
                    body: message,
                    sound: "default"
                }
            },
            apns: {
                payload: {
                    aps: {
                        sound: "default"
                    }
                }
            }

        })
    }
}


exports.SendTestNotificationToUser = functions.https.onCall(async(req, res) => {
    // console.log(req.body.docId);
    console.log(req.docId);



    var totalSent = [];
    try {
        var userRef = firestore.collection('employee_tokens').get();
        (await userRef).docs.forEach(async(emp) => {

            var userData = emp.data();
            const token = await userData.token
            const isEmployeeActive = await userData.isActive
                //     const tokens = tokenSnapshot.docs.map(snap => snap.id);
            if (token != null && isEmployeeActive == true) {

                var data = JSON.stringify({
                    "to": token,
                    "collapse_key": "type_a",
                    "data": {
                        "click_action": "FLUTTER_NOTIFICATION_CLICK",
                        "sound": "default",
                        "body": "!!! bahadur is in emergency!!!",
                        "title": "Emergency Alert!!!",
                        "content_available": true,
                        "priority": "high",
                        "screen": "screen",
                        "badge": "1",
                        "payload": req.docId
                    },
                    "android": {
                        "notification": {
                            "channel_id": "men"
                        }
                    },
                    "apns": {
                        "payload": {
                            "aps": {
                                "sound": "default"
                            }
                        }
                    }
                });

                var config = {
                    method: 'post',
                    url: 'https://fcm.googleapis.com/fcm/send',
                    headers: {
                        'Authorization': 'key=AAAA09RalxY:APA91bHeFpDnPfH6WajNPG-xw3_92HSDtPMDchxr_UFVglebEQ7rQC5xAWloKmpARzQRL-DjfYFVw970qnMjQ8C98jbv_Dz8jFy7AF2mjQyDeoJGg6PsZnOLEEYeOcmRdFfhhmchdc1t',
                        'Content-Type': 'application/json'
                    },
                    data: data
                };

                var res = await axios(config);
                console.log("sent", JSON.stringify(res.data));
                totalSent.push("sent");

                // totalSent.push(JSON.stringify(res));
                // console.log(JSON.stringify(res));


            } else {
                console.log("not active.");
            }
        })
        return functions.https.onRequest(
            "status",
            "200"
        )

        // await sendTestNotificationToEmployee("h", " ahaha ahha ahaha")

        // res.status(200).send("sent");

    } catch (e) {
        console.error(e);
        return functions.https.HttpsError(
                "status",
                "400"
            )
            // res.status(404).send({ success: false, error: e.message })
    }
})

// exports.OnSubscriptionAdded = functions.firestore.document('users/{userId}/subscriptions/{docId}').onCreate(async(snapshot, ctx) => {
//     console.info("******************HITTING FOR subscriptions************************");
//     const documentData = snapshot.data();

//     // const phoneNumberToSearch = documentData.phoneNumber.toString().replace("+", "").trim();
//     try {
//         var userRef = firestore.collection('users');
//         const phoneNumberToSearch = documentData.metadata.number;
//         console.log("❗ SUBSCRIPTION AND GOT THIS NUMBER ❗❗❗❗❗❗==============>", phoneNumberToSearch);
//         // documentData.metadata["number"];
//         var matchedUsers = await userRef.where("phone", "==", "+" + phoneNumberToSearch).get();
//         console.log();
//         if (matchedUsers.empty) {
//             console.log("❗❗❗❗ Notihing found against the " + phoneNumberToSearch + " number");
//             return;
//         }


//         matchedUsers.forEach(user => {
//             snapshot.ref.update({
//                 "userId": user.id
//             }, { merge: true });

//         });

//     } catch (e) {
//         console.error("❗ errrrrr", e);
//     }



// });


//THIS FUNCTION IS FOR TESTING OF SCHEDULE USER CHECK OF EXPIREATION
// exports.ScheduleHttpWorkTest = functions.https.onRequest(async(req, res) => {

//     try {
//         console.log('scheduleRecurringTransection started');
//         const snapshot = await firestore.collection('users').get();
//         console.log("total users to check: ", snapshot.size);

//         for (const doc of snapshot.docs) {

//             try {
//                 var userData = doc.data();
//                 if (userData.isSubscriptionExpired != true) {
//                     console.info("===========> FOR ID " + userData.userId + "<===========");
//                     //IF INVITED BY GUARDIAN THEN IT MEANS THEIR SUBSCRIPTION DATA IS IN THEIR DOC...
//                     if (userData.guardianPaymentPath != undefined) {
//                         console.info("****================> IF CASE <============================****");
//                         var arr = userData.guardianPaymentPath.split('/');
//                         //MAKING PATH TO REACH GUARDIAN DOC ID.
//                         var detail = await firestore.collection(arr[0]).doc(arr[1]).collection(arr[2] + "s").doc(arr[3]).get();
//                         var subcriptionData = detail.data();
//                         if (subcriptionData != undefined && subcriptionData.status != "active") {
//                             ///ENDING SUBSCRIPTION HERE IF STATUS IS NOT ACTIVE..
//                             console.log("😱😱😱 Subscription ended for user => " + userData.userId + " because status is " + subcriptionData.status);
//                             await firestore.collection("users").doc(userData.userId).set({
//                                 "isSubscriptionExpired": true
//                             }, { merge: true });

//                         }
//                     } else {
//                         console.info("****================> ELSE CASE <============================*****");
//                         //For Account itself subscription
//                         var subscriptions = await firestore.collection("users").doc(userData.userId).collection("subscriptions").get();



//                         let subscriptionStatus = "expired";
//                         //checking if any of status is active then it means its perfect.
//                         for (const subscription of subscriptions.docs) {
//                             var subscriptionData = subscription.data();
//                             console.log(subscriptionData.status);

//                             //meta data check is for to avoid subscription from others as if meta data is not null that means he have bought that specific subscription for someone else and not for himself so avoiding that.
//                             if (subscriptionData.status != undefined && subscriptionData.status == "active" && subscriptionData.metadata == "" || subscriptionData.metadata == undefined) {
//                                 subscriptionStatus = "active";
//                             }
//                         }

//                         console.log("IMP PLACE>>>>" + subscriptionStatus);
//                         if (subscriptionStatus != "active" && subscriptionData != undefined) {
//                             ///ENDING SUBSCRIPTION HERE IF STATUS IS NOT ACTIVE..
//                             console.log("😱😱😱 else case for Subscription ended for user => " + userData.userId + " because status is " + subscriptionData.status);
//                             await firestore.collection("users").doc(userData.userId).set({
//                                 "isSubscriptionExpired": true
//                             }, { merge: true });

//                         }
//                     }
//                 } else {
//                     console.log("skipped because status is true ", userData.userId);
//                 }

//             } catch (e) {
//                 console.log("-")
//                 console.error(e);
//                 console.log("-")
//             }







//         }
//         res.status(200).send({
//             "users_checked_total": snapshot.size
//         });
//     } catch (e) {
//         console.log("Exception in Schedule Recurring Transaction");
//         console.error(e);
//         res.status(200).send(e);

//     }

//     console.log('scheduleRecurringTransection ended');

// });
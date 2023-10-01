import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../data/models/group_model.dart';

class GroupsData {
  final List<GroupModel> groups = [
    GroupModel(
      name: 'Family',
      createdAt: '01 june,2023',
      isActive: true,
      members: [
        CustomContactModel(
          name: "Samantha",
          position: const LatLng(
            37.42484642575639,
            -122.08309359848501,
          ),
          marker: 'assets/markers/marker-2.png',
          image: 'assets/images/avatar-2.png',
        ),
        CustomContactModel(
          name: "Malte",
          position: const LatLng(
            37.42381625902441,
            -122.0928531512618,
          ),
          marker: 'assets/markers/marker-3.png',
          image: 'assets/images/avatar-3.png',
        ),
        CustomContactModel(
          name: "Julia",
          position: const LatLng(
            37.41994095849639,
            -122.08159055560827,
          ),
          marker: 'assets/markers/marker-4.png',
          image: 'assets/images/avatar-4.png',
        ),
      ],
    ),
    GroupModel(
      name: 'School',
      createdAt: '01 july,2023',
      isActive: true,
      members: [
        CustomContactModel(
          name: "Tim",
          position: const LatLng(37.413175077529935, -122.10101041942836),
          marker: 'assets/markers/marker-5.png',
          image: 'assets/images/avatar-5.png',
        ),
        CustomContactModel(
          name: "Sara",
          position: const LatLng(37.419013242401576, -122.11134664714336),
          marker: 'assets/markers/marker-6.png',
          image: 'assets/images/avatar-6.png',
        ),
        CustomContactModel(
          name: "Julia",
          position: const LatLng(
            37.41994095849639,
            -122.08159055560827,
          ),
          marker: 'assets/markers/marker-4.png',
          image: 'assets/images/avatar-4.png',
        ),
      ],
    ),
    GroupModel(
      name: 'Senior Travel Club',
      createdAt: '13 june,2023',
      isActive: true,
      members: [
        CustomContactModel(
          name: "Julia",
          position: const LatLng(
            37.41994095849639,
            -122.08159055560827,
          ),
          marker: 'assets/markers/marker-4.png',
          image: 'assets/images/avatar-4.png',
        ),
        CustomContactModel(
          name: "Tim",
          position: const LatLng(37.413175077529935, -122.10101041942836),
          marker: 'assets/markers/marker-5.png',
          image: 'assets/images/avatar-5.png',
        ),
        CustomContactModel(
          name: "Sara",
          position: const LatLng(37.419013242401576, -122.11134664714336),
          marker: 'assets/markers/marker-6.png',
          image: 'assets/images/avatar-6.png',
        ),
        CustomContactModel(
          name: "Samantha",
          position: const LatLng(
            37.42484642575639,
            -122.08309359848501,
          ),
          marker: 'assets/markers/marker-2.png',
          image: 'assets/images/avatar-2.png',
        ),
        CustomContactModel(
          name: "Malte",
          position: const LatLng(
            37.42381625902441,
            -122.0928531512618,
          ),
          marker: 'assets/markers/marker-3.png',
          image: 'assets/images/avatar-3.png',
        ),
      ],
    ),
  ];
}

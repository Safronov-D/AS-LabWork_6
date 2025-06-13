import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cubit/nasa_cubit.dart';
import 'requests/nasa_api.dart';
import 'models/photo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA Spirit Rover',
      theme: ThemeData.dark(),
      home: BlocProvider(
        create: (context) => NasaCubit(NasaApi())..fetchPhotos(),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spirit Rover - Sol 50'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => context.read<NasaCubit>().fetchPhotos(),
          )
        ],
      ),
      body: BlocBuilder<NasaCubit, NasaState>(
        builder: (context, state) {
          if (state is NasaLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NasaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<NasaCubit>().fetchPhotos(),
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (state is NasaLoaded) {
            return _buildPhotoList(state.photos);
          }
          return Center(child: Text('Press refresh to load data'));
        },
      ),
    );
  }

  Widget _buildPhotoList(List<Photo> photos) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return Card(
          margin: EdgeInsets.all(8),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Изображение с HTTPS
              CachedNetworkImage(
                imageUrl: photo.imgSrc,
                httpHeaders: const {'User-Agent': 'NASA-Rover-App/1.0'},
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[800],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[800],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 48),
                        SizedBox(height: 8),
                        Text('Failed to load image'),
                      ],
                    ),
                  ),
                ),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Camera: ${photo.camera.fullName}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Earth Date: ${_formatDate(photo.earthDate)}'),
                    SizedBox(height: 4),
                    Text('Mission Days: ${photo.sol} sol'),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text('Rover Status: '),
                        Text(
                          photo.rover.status.toUpperCase(),
                          style: TextStyle(
                            color: photo.rover.status == 'active' 
                                ? Colors.green 
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Mission Details:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Launched: ${_formatDate(photo.rover.launchDate)}'),
                    Text('Landed: ${_formatDate(photo.rover.landingDate)}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
// lib/screens/movie_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simple_authentication/model/movie.dart';
import '../../services/tmdb_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({required this.movieId, super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final TmdbService _tmdb = TmdbService();
  Movie? _movie;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final details = await _tmdb.getMovieDetails(widget.movieId);
      setState(() {
        _movie = details;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _tmdb.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_movie?.title ?? 'Movie')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_movie!.posterPath != null &&
                        _movie!.posterPath!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Hero(
                          tag: 'poster_${_movie!.id}', // match the tag used in the home screen
                          child: CachedNetworkImage(
                            imageUrl: _movie!.posterUrl,
                            height: 420,
                            fit: BoxFit.cover,
                            placeholder: (c, s) => Container(
                              height: 420,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (c, s, e) => Container(
                              height: 420,
                              color: Colors.black12,
                              child: Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    Text(
                      _movie!.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        if (_movie!.voteAverage != null) ...[
                          Icon(Icons.star, size: 18, color: Colors.amber),
                          SizedBox(width: 6),
                          Text('${_movie!.voteAverage} / 10'),
                        ],
                        Spacer(),
                        if (_movie!.releaseDate != null)
                          Text(_movie!.releaseDate!),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      _movie!.overview ?? 'No overview available',
                      style: TextStyle(height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

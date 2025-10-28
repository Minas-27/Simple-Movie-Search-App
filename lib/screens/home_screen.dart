// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_authentication/model/movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simple_authentication/screens/profile_screen.dart';

import '../../services/tmdb_service.dart';
import '../favorite_service.dart';
import 'favourites_screen.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _searchController = TextEditingController();
  final TmdbService _tmdb = TmdbService();

  List<Movie> _results = [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    _tmdb.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final q = _searchController.text.trim();
    if (q.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final movies = await _tmdb.searchMovies(q);
      setState(() => _results = movies);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

// Load favorites for the user
  Future<void> _loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favorites = await FavoriteService.loadFavorites(user.uid);
    final favoriteIds = favorites.map((f) => f.id).toSet();
    setState(() {
      for (var m in _results) {
        m.isFavorite = favoriteIds.contains(m.id);
      }
    });
  }



  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: 'Search movies (e.g. Joker)',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _search,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie m) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: m.id)),
      ),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              child: m.posterPath != null && m.posterPath!.isNotEmpty
                  ? Hero(
                tag: 'poster_${m.id}',
                child: CachedNetworkImage(
                  imageUrl: m.posterUrl,
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                  placeholder: (c, s) =>
                      SizedBox(width: 100, height: 150, child: Center(child: CircularProgressIndicator())),
                  errorWidget: (c, s, e) =>
                      Container(width: 100, height: 150, color: Colors.black12, child: Icon(Icons.broken_image)),
                ),
              )
                  : Container(width: 100, height: 150, color: Colors.black12, child: Icon(Icons.movie, size: 40)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    if (m.releaseDate != null)
                      Text('Release: ${m.releaseDate}', style: TextStyle(color: Colors.black54)),
                    SizedBox(height: 8),
                    if (m.voteAverage != null)
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 6),
                          Text('${m.voteAverage} / 10'),
                        ],
                      ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            m.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            setState(() {
                              m.isFavorite = !m.isFavorite;
                            });
                            final user = _auth.currentUser;
                            if (user == null) return;

                            if (m.isFavorite) {
                              await FavoriteService.addFavorite(user.uid, FavoriteMovie(
                                id: m.id,
                                title: m.title,
                                posterPath: m.posterPath,
                              ));
                            } else {
                              await FavoriteService.removeFavorite(user.uid, m.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    if (_results.isEmpty) {
      return Center(
          child: Text(
            'No movies found 😔\nTry another search.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black54),
          )
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 16, top: 8),
      itemCount: _results.length,
      itemBuilder: (_, i) => _buildMovieCard(_results[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Search'),
        actions: [
          if (_auth.currentUser != null) ...[
            IconButton(
              icon: Icon(Icons.person_2_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(user: _auth.currentUser!),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite_border_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FavoritesScreen()), // no parameters needed
                );
              },
            ),
          ]
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}

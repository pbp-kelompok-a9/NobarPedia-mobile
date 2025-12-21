import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nobarpedia_mobile/homepage/models/spot_entry.dart';
import 'package:nobarpedia_mobile/homepage/screen/spot_detail.dart';
import 'package:nobarpedia_mobile/config.dart';

// [ADDED]: Helper function to check admin status
Future<bool> checkAdmin(CookieRequest request) async {
  try {
    // Ensure URL is correct based on your django urls.py
    var response = await request.get('$baseUrl/account/api/admin/');
    // Handle dynamic response (String or Map) safely
    var data = (response is String) ? jsonDecode(response) : response;
    return data["status"] == true;
  } catch (e) {
    return false;
  }
}

// ==========================================
// 1. DATA MODELS
// ==========================================
// ... [Models Player, Competition, EnrichedMatch remain unchanged] ...
class Player {
  final String id;
  final String name;
  final String? logo;
  final String establishedDate;
  final bool isDefunct;

  Player({
    required this.id,
    required this.name,
    this.logo,
    required this.establishedDate,
    required this.isDefunct,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    var fields = json['fields'];
    return Player(
      id: json['pk'],
      name: fields['name'],
      logo: fields['logo'],
      establishedDate: fields['established_date'],
      isDefunct: fields['is_defunct'] ?? false,
    );
  }
}

class Competition {
  final String id;
  final String name;
  final String? logo;
  final String beginDate;
  final String endDate;

  Competition({
    required this.id,
    required this.name,
    this.logo,
    required this.beginDate,
    required this.endDate,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    var fields = json['fields'];
    return Competition(
      id: json['pk'],
      name: fields['name'],
      logo: fields['logo'],
      beginDate: fields['begin_date'],
      endDate: fields['end_date'],
    );
  }
}

class EnrichedMatch {
  final String id;
  final Competition competition;
  final List<Player> players;
  final List<SpotEntry> spots;
  final DateTime beginDatetime;
  final DateTime endDatetime;

  EnrichedMatch({
    required this.id,
    required this.competition,
    required this.players,
    required this.spots,
    required this.beginDatetime,
    required this.endDatetime,
  });
}

// ==========================================
// 2. MAIN SCREEN
// ==========================================

class MatchMenu extends StatefulWidget {
  const MatchMenu({Key? key}) : super(key: key);

  @override
  State<MatchMenu> createState() => _MatchMenuState();
}

class _MatchMenuState extends State<MatchMenu> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isAdminUser = false; // [MODIFIED]: Default to false, fetch real status

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    
    // [ADDED]: Fetch admin status on load
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final request = context.read<CookieRequest>();
      bool status = await checkAdmin(request);
      if (mounted) setState(() => isAdminUser = status);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1c1917),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: "Matches"),
            Tab(text: "Competitions"),
            Tab(text: "Players"),
          ],
        ),
        title: const Text("Nobar Sport Matches"),
      ),
      body: Container(
        color: const Color(0xFF1c1917),
        child: TabBarView(
          controller: _tabController,
          // [CRITICAL FIX]: Removed 'const' so setState() triggers rebuilds of children
          children: [
            MatchList(isAdmin: isAdminUser),
            CompetitionList(isAdmin: isAdminUser),
            PlayerList(isAdmin: isAdminUser),
          ],
        ),
      ),
      floatingActionButton: isAdminUser ? _buildFab(context) : null,
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: const Icon(Icons.add),
      onPressed: () async {
        // [MODIFIED]: Wait for navigation AND delay for DB commit
        if (_tabController.index == 0) {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchFormPage()));
        } else if (_tabController.index == 1) {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const CompetitionFormPage()));
        } else {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerFormPage()));
        }

        if (context.mounted) {
           // [ADDED]: 500ms delay to ensure backend has processed the write
           await Future.delayed(const Duration(milliseconds: 500));
           setState(() {}); // Rebuilds TabBarView children
        }
      },
    );
  }
}

// ==========================================
// 3. TAB: MATCH LIST
// ==========================================

class MatchList extends StatefulWidget {
  final bool isAdmin; // [ADDED]
  const MatchList({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<MatchList> createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  // Use 10.0.2.2 for Android Emulator, 127.0.0.1 for Web/iOS
  
  // ... [fetchMatches method and helper _parseDjangoResponse remain same] ...
  List<dynamic> _parseDjangoResponse(dynamic response) {
    if (response is String) {
      try {
        var parsed = jsonDecode(response);
        if (parsed is String) return jsonDecode(parsed);
        return parsed;
      } catch (e) { return []; }
    } 
    return [];
  }

  Future<List<EnrichedMatch>> fetchMatches(CookieRequest request) async {
    final response = await request.get('$baseUrl/match/api/match/post/read_all_match/');
    
    List<dynamic> initialData = [];
    if (response is String) {
       initialData = jsonDecode(response);
    } else {
       if (response is String) initialData = jsonDecode(response);
       else initialData = response is List ? response : jsonDecode(response.toString());
    }

    List<EnrichedMatch> enrichedList = [];
    // ... [Parsing logic remains exactly the same as previous working version] ...
    for (var item in initialData) {
      var fields = item['fields'];
      String compId = fields['competition'];
      final compRes = await request.get('$baseUrl/match/api/match/post/read_competition/$compId/');
      var compData = (compRes is String) ? jsonDecode(compRes) : compRes;
      if (compData is String) compData = jsonDecode(compData); 
      Competition competition = Competition.fromJson(compData[0]);

      List<String> playerIds = List<String>.from(fields['players']);
      List<Player> players = [];
      for (String pid in playerIds) {
        final playRes = await request.get('$baseUrl/match/api/match/post/read_player/$pid/');
        var playData = (playRes is String) ? jsonDecode(playRes) : playRes;
        if (playData is String) playData = jsonDecode(playData);
        players.add(Player.fromJson(playData[0]));
      }

      List<SpotEntry> spots = [];
      try {
        final spotRes = await request.get('$baseUrl/match/api/match/get_spots/${item['pk']}/'); 
        var spotData = (spotRes is String) ? jsonDecode(spotRes) : spotRes;
        if (spotData is String) spotData = jsonDecode(spotData);

        spots = (spotData as List).map((s) {
          Map<String, dynamic> flatJson = Map<String, dynamic>.from(s['fields']);
          flatJson['id'] = s['pk'];
          return SpotEntry.fromJson(flatJson);
        }).toList();
      } catch (e) {
        // print("Spot fetch error: $e");
      }

      enrichedList.add(EnrichedMatch(
        id: item['pk'],
        competition: competition,
        players: players,
        spots: spots,
        beginDatetime: DateTime.parse(fields['begin_datetime']),
        endDatetime: DateTime.parse(fields['end_datetime']),
      ));
    }
    return enrichedList;
  }

  Future<void> deleteMatch(CookieRequest request, String id) async {
    await request.post('$baseUrl/match/api/match/post/delete_match/$id/', {});
    // [ADDED]: Delay before refresh
    await Future.delayed(const Duration(milliseconds: 500)); 
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return FutureBuilder(
      future: fetchMatches(request),
      builder: (context, AsyncSnapshot<List<EnrichedMatch>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No matches found", style: TextStyle(color: Colors.white)));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final match = snapshot.data![index];
            final p1 = match.players.isNotEmpty ? match.players[0] : null;
            final p2 = match.players.length > 1 ? match.players[1] : null;

            return Card(
              color: const Color(0xFF292524),
              margin: const EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (widget.isAdmin) // [MODIFIED]: Use passed prop
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                                await Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (_) => MatchFormPage(match: match))
                                );
                                // [ADDED]: Delay after edit
                                await Future.delayed(const Duration(milliseconds: 500));
                                setState((){});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteMatch(request, match.id),
                          ),
                        ],
                      ),
                    // ... [Rest of Match UI is same] ...
                    Text(match.competition.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      "${DateFormat('MMM dd, HH:mm').format(match.beginDatetime)} - ${DateFormat('HH:mm').format(match.endDatetime)}",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTeamColumn(p1),
                        const Text("VS", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        _buildTeamColumn(p2),
                      ],
                    ),
                    const Divider(color: Colors.white24),
                    if (match.spots.isNotEmpty)
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: match.spots.length,
                          itemBuilder: (context, i) {
                            final spot = match.spots[i];
                            return InkWell(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SpotDetailPage(spot: spot))),
                              child: Container(
                                width: 100, margin: const EdgeInsets.only(right: 8, top: 8),
                                color: Colors.black26,
                                child: Column(children: [
                                  Expanded(child: Image.network(spot.thumbnail, fit: BoxFit.cover, errorBuilder: (_,__,___)=>const Icon(Icons.error))),
                                  Text(spot.name, style: const TextStyle(color: Colors.white, fontSize: 10), overflow: TextOverflow.ellipsis)
                                ]),
                              ),
                            );
                          },
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTeamColumn(Player? p) {
    return Column(
      children: [
        if (p?.logo != null) Image.network(p!.logo!, width: 40, height: 40, errorBuilder: (_,__,___)=> const Icon(Icons.shield, color: Colors.white))
        else const Icon(Icons.shield, color: Colors.white, size: 40),
        Text(p?.name ?? "TBD", style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

// ==========================================
// 4. TAB: COMPETITION & PLAYER LISTS
// ==========================================

class CompetitionList extends StatefulWidget {
  final bool isAdmin; // [ADDED]
  const CompetitionList({Key? key, required this.isAdmin}) : super(key: key);
  @override
  State<CompetitionList> createState() => _CompetitionListState();
}

class _CompetitionListState extends State<CompetitionList> {
  // Use widget.isAdmin

  Future<List<Competition>> fetchCompetitions(CookieRequest request) async {
    final response = await request.get('$baseUrl/match/api/match/post/read_all_competition/');
    var data = (response is String) ? jsonDecode(response) : response;
    if (data is String) data = jsonDecode(data); 
    return (data as List).map((d) => Competition.fromJson(d)).toList();
  }

  Future<void> deleteCompetition(CookieRequest request, String id) async {
    await request.post('$baseUrl/match/api/match/post/delete_competition/$id/', {});
    // [ADDED]: Delay
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder(
      future: fetchCompetitions(request),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final comp = snapshot.data![index];
            return Card(
              color: const Color(0xFF292524),
              child: ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.amber),
                title: Text(comp.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text("${comp.beginDate} - ${comp.endDate}", style: const TextStyle(color: Colors.white70)),
                trailing: widget.isAdmin ? Row( // [MODIFIED]
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue), 
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => CompetitionFormPage(competition: comp)));
                        await Future.delayed(const Duration(milliseconds: 500));
                        setState((){});
                      }
                    ),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => deleteCompetition(request, comp.id)),
                  ],
                ) : null,
              ),
            );
          },
        );
      },
    );
  }
}

class PlayerList extends StatefulWidget {
  final bool isAdmin; // [ADDED]
  const PlayerList({Key? key, required this.isAdmin}) : super(key: key);
  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  
  Future<List<Player>> fetchPlayers(CookieRequest request) async {
    final response = await request.get('$baseUrl/match/api/match/post/read_all_player/');
    var data = (response is String) ? jsonDecode(response) : response;
    if (data is String) data = jsonDecode(data); 
    return (data as List).map((d) => Player.fromJson(d)).toList();
  }

  Future<void> deletePlayer(CookieRequest request, String id) async {
    await request.post('$baseUrl/match/api/match/post/delete_player/$id/', {});
    // [ADDED]: Delay
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder(
      future: fetchPlayers(request),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final p = snapshot.data![index];
            return Card(
              color: const Color(0xFF292524),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: Text(p.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text(p.isDefunct ? "Defunct" : p.establishedDate, style: TextStyle(color: p.isDefunct ? Colors.red : Colors.white70)),
                trailing: widget.isAdmin ? Row( // [MODIFIED]
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue), 
                      onPressed: () async {
                         await Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerFormPage(player: p)));
                         await Future.delayed(const Duration(milliseconds: 500));
                         setState((){});
                      }
                    ),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => deletePlayer(request, p.id)),
                  ],
                ) : null,
              ),
            );
          },
        );
      },
    );
  }
}

// ==========================================
// 5. FORMS
// ==========================================

class CompetitionFormPage extends StatefulWidget {
  final Competition? competition;
  const CompetitionFormPage({Key? key, this.competition}) : super(key: key);
  @override
  State<CompetitionFormPage> createState() => _CompetitionFormPageState();
}

class _CompetitionFormPageState extends State<CompetitionFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _logo = "";
  DateTime _beginDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    if (widget.competition != null) {
      _name = widget.competition!.name;
      _logo = widget.competition!.logo ?? "";
      _beginDate = DateTime.parse(widget.competition!.beginDate);
      _endDate = DateTime.parse(widget.competition!.endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.competition == null ? "Add Competition" : "Edit Competition")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: (v) => _name = v,
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            TextFormField(
              initialValue: _logo,
              decoration: const InputDecoration(labelText: "Logo URL"),
              onChanged: (v) => _logo = v,
            ),
            ListTile(
              title: Text("Begin: ${DateFormat('yyyy-MM-dd').format(_beginDate)}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _beginDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
                if (d != null) setState(() => _beginDate = d);
              },
            ),
            ListTile(
              title: Text("End: ${DateFormat('yyyy-MM-dd').format(_endDate)}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _endDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
                if (d != null) setState(() => _endDate = d);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final Map<String, dynamic> body = {
                    "name": _name,
                    "logo": _logo,
                    "begin_date": DateFormat('yyyy-MM-dd').format(_beginDate),
                    "end_date": DateFormat('yyyy-MM-dd').format(_endDate),
                  };
                  final url = widget.competition == null
                      ? '$baseUrl/match/api/match/post/create_competition/'
                      : '$baseUrl/match/api/match/post/update_competition/${widget.competition!.id}/';
                  
                  await request.post(url, body);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}

class PlayerFormPage extends StatefulWidget {
  final Player? player;
  const PlayerFormPage({Key? key, this.player}) : super(key: key);
  @override
  State<PlayerFormPage> createState() => _PlayerFormPageState();
}

class _PlayerFormPageState extends State<PlayerFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _logo = "";
  DateTime _estDate = DateTime.now();
  bool _isDefunct = false;

  @override
  void initState() {
    super.initState();
    if (widget.player != null) {
      _name = widget.player!.name;
      _logo = widget.player!.logo ?? "";
      _estDate = DateTime.parse(widget.player!.establishedDate);
      _isDefunct = widget.player!.isDefunct;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.player == null ? "Add Player" : "Edit Player")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: (v) => _name = v,
            ),
            TextFormField(
              initialValue: _logo,
              decoration: const InputDecoration(labelText: "Logo URL"),
              onChanged: (v) => _logo = v,
            ),
            CheckboxListTile(
              title: const Text("Is Defunct?"),
              value: _isDefunct,
              onChanged: (v) => setState(() => _isDefunct = v!),
            ),
            ListTile(
              title: Text("Established: ${DateFormat('yyyy-MM-dd').format(_estDate)}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _estDate, firstDate: DateTime(1900), lastDate: DateTime.now());
                if (d != null) setState(() => _estDate = d);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                   final Map<String, dynamic> body = {
                    "name": _name,
                    "logo": _logo,
                    "established_date": DateFormat('yyyy-MM-dd').format(_estDate),
                    "is_defunct": _isDefunct.toString(), 
                  };
                  final url = widget.player == null
                      ? '$baseUrl/match/api/match/post/create_player/'
                      : '$baseUrl/match/api/match/post/update_player/${widget.player!.id}/';
                  
                  try {
                    // Send as JSON
                    await request.post(url, jsonEncode(body));
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (e.toString().contains("Unexpected end of input")) {
                      if (context.mounted) Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  }
                }
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}

class MatchFormPage extends StatefulWidget {
  final EnrichedMatch? match;
  const MatchFormPage({Key? key, this.match}) : super(key: key);
  @override
  State<MatchFormPage> createState() => _MatchFormPageState();
}

class _MatchFormPageState extends State<MatchFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedCompetitionId;
  List<String> _selectedPlayerIds = [];
  List<String> _selectedSpotIds = []; 
  DateTime _begin = DateTime.now();
  DateTime _end = DateTime.now().add(const Duration(hours: 2));

  List<Competition> _competitions = [];
  List<Player> _players = [];
  List<SpotEntry> _spots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDependencies();
  }

  Future<void> _fetchDependencies() async {
    final request = context.read<CookieRequest>();
    
    try {
      final compRes = await request.get('$baseUrl/match/api/match/post/read_all_competition/');
      var compData = (compRes is String) ? jsonDecode(compRes) : compRes;
      if (compData is String) compData = jsonDecode(compData);

      final playRes = await request.get('$baseUrl/match/api/match/post/read_all_player/');
      var playData = (playRes is String) ? jsonDecode(playRes) : playRes;
      if (playData is String) playData = jsonDecode(playData);

      final spotRes = await request.get('$baseUrl/json/'); 
      var spotData = (spotRes is String) ? jsonDecode(spotRes) : spotRes;
      
      setState(() {
        _competitions = (compData as List).map((d) => Competition.fromJson(d)).toList();
        _players = (playData as List).map((d) => Player.fromJson(d)).toList();
        _spots = (spotData as List).map((d) => SpotEntry.fromJson(d)).toList();

        if (widget.match != null) {
          _selectedCompetitionId = widget.match!.competition.id;
          _selectedPlayerIds = widget.match!.players.map((p) => p.id).toList();
          _selectedSpotIds = widget.match!.spots.map((s) => s.id).toList();
          _begin = widget.match!.beginDatetime;
          _end = widget.match!.endDatetime;
        }
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching dependencies: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: Text(widget.match == null ? "Create Match" : "Edit Match")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCompetitionId,
              decoration: const InputDecoration(labelText: "Competition", border: OutlineInputBorder()),
              items: _competitions.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              onChanged: (v) => setState(() => _selectedCompetitionId = v),
              validator: (v) => v == null ? "Required" : null,
            ),
            const SizedBox(height: 20),
            
            const Text("Select Teams (Players)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
              child: ListView.builder(
                itemCount: _players.length,
                itemBuilder: (context, index) {
                  final p = _players[index];
                  final isSelected = _selectedPlayerIds.contains(p.id);
                  return CheckboxListTile(
                    dense: true,
                    title: Text(p.name),
                    value: isSelected,
                    onChanged: (bool? val) {
                      setState(() {
                        if (val == true) _selectedPlayerIds.add(p.id);
                        else _selectedPlayerIds.remove(p.id);
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            const Text("Select Spots (Shown At)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
              child: _spots.isEmpty 
                ? const Center(child: Text("No spots available.")) 
                : ListView.builder(
                    itemCount: _spots.length,
                    itemBuilder: (context, index) {
                      final s = _spots[index];
                      final isSelected = _selectedSpotIds.contains(s.id);
                      return CheckboxListTile(
                        dense: true,
                        title: Text(s.name),
                        subtitle: Text(s.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                        secondary: SizedBox(
                          width: 40, height: 40,
                          child: Image.network(s.thumbnail, fit: BoxFit.cover, errorBuilder: (_,__,___)=>const Icon(Icons.broken_image)),
                        ),
                        value: isSelected,
                        onChanged: (bool? val) {
                          setState(() {
                            if (val == true) _selectedSpotIds.add(s.id);
                            else _selectedSpotIds.remove(s.id);
                          });
                        },
                      );
                    },
                  ),
            ),
            const SizedBox(height: 20),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Start: ${DateFormat('yyyy-MM-dd HH:mm').format(_begin)}"),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _begin, firstDate: DateTime(2020), lastDate: DateTime(2030));
                if (d != null) {
                   final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_begin));
                   if (t != null) setState(() => _begin = DateTime(d.year, d.month, d.day, t.hour, t.minute));
                }
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("End: ${DateFormat('yyyy-MM-dd HH:mm').format(_end)}"),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _end, firstDate: DateTime(2020), lastDate: DateTime(2030));
                if (d != null) {
                   final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_end));
                   if (t != null) setState(() => _end = DateTime(d.year, d.month, d.day, t.hour, t.minute));
                }
              },
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                   final Map<String, dynamic> body = {
                    "competition": _selectedCompetitionId,
                    "begin_datetime": _begin.toIso8601String(),
                    "end_datetime": _end.toIso8601String(),
                    "players": _selectedPlayerIds, 
                    "shownAt": _selectedSpotIds,
                  };
                  
                  final url = widget.match == null
                      ? '$baseUrl/match/api/match/post/create_match/'
                      : '$baseUrl/match/api/match/post/update_match/${widget.match!.id}/';
                  
                  try {
                    await request.post(url, jsonEncode(body));
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (e.toString().contains("Unexpected end of input")) {
                       if (context.mounted) Navigator.pop(context);
                    } else {
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  }
                }
              },
              child: const Text("Save Match", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}

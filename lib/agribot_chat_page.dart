// agribot_chat_page.dart — AgriBot Flutter page v7
// - English only (multilingual removed)
// - User bubble color updated to match app theme (#1B6B2F)
// - No PDF source tags shown

import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const String kBaseUrl = 'https://safarnxma-agribot-backend.hf.space';

// ─── Colours ──────────────────────────────────────────────────────────────────
const _green          = Color(0xFF4A8C1C);
const _greenDark      = Color(0xFF3B6D11);
const _greenLight     = Color(0xFFE2F5C8);
const _greenPale      = Color(0xFFF0FADF);
const _userBubble     = Color(0xFF1B6B2F);
const _bgColor        = Color(0xFFF6F6F3);
const _surface        = Color(0xFFFFFFFF);
const _border         = Color(0x14000000);
const _borderMid      = Color(0x24000000);
const _textMain       = Color(0xFF1C1C1C);
const _textMuted      = Color(0xFF6B6B6B);
const _textHint       = Color(0xFFB0B0B0);
const _dBg            = Color(0xFFFFF2F2);
const _dText          = Color(0xFF8B2020);
const _dBorder        = Color(0xFFF5BFBF);
const _pBg            = Color(0xFFFFF8ED);
const _pText          = Color(0xFF7A4800);
const _pBorder        = Color(0xFFF5D490);

// ─── Models ───────────────────────────────────────────────────────────────────
class _SuggestedQuestion {
  final String id, category, topic, question;
  const _SuggestedQuestion({required this.id, required this.category,
    required this.topic, required this.question});
  factory _SuggestedQuestion.fromJson(Map<String, dynamic> j) =>
      _SuggestedQuestion(id: j['id'] ?? '', category: j['category'] ?? '',
          topic: j['topic'] ?? '', question: j['question'] ?? '');
}

enum _Sender { user, bot }

class _ChatMessage {
  final String text;
  final _Sender sender;
  final DateTime timestamp;
  final List<_SuggestedQuestion> followups;
  final bool isError;
  const _ChatMessage({required this.text, required this.sender,
    required this.timestamp, this.followups = const [], this.isError = false});
}

// ═════════════════════════════════════════════════════════════════════════════
// ENTRY POINT — goes straight to chat (no language selection)
// ═════════════════════════════════════════════════════════════════════════════

class AgribotChatPage extends StatelessWidget {
  const AgribotChatPage({super.key});
  @override
  Widget build(BuildContext context) => const _ChatScreen();
}

// ═════════════════════════════════════════════════════════════════════════════
// CHAT SCREEN
// ═════════════════════════════════════════════════════════════════════════════

class _ChatScreen extends StatefulWidget {
  const _ChatScreen();
  @override
  State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> with TickerProviderStateMixin {
  final List<_ChatMessage> _messages = [];
  final List<Map<String, String>> _history = [];
  bool _showWelcome = true;
  bool _isTyping    = false;

  List<_SuggestedQuestion> _allDiseases    = [];
  List<_SuggestedQuestion> _allPests       = [];
  List<_SuggestedQuestion> _previewDiseases = [];
  List<_SuggestedQuestion> _previewPests    = [];

  final _controller = TextEditingController();
  final _focusNode  = FocusNode();
  final _scrollCtrl = ScrollController();
  late AnimationController _dotAnim;

  @override
  void initState() {
    super.initState();
    _dotAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat();
    _loadQuestions();
  }

  @override
  void dispose() {
    _dotAnim.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _greetPeriod() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return 'MORNING';
    if (h >= 12 && h < 17) return 'AFTERNOON';
    return 'EVENING';
  }

  String _fmtTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  String _fmtDate(DateTime d) {
    const wd = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    const mo = ['January','February','March','April','May','June',
      'July','August','September','October','November','December'];
    return '${wd[d.weekday - 1]}, ${mo[d.month - 1]} ${d.day}';
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  // ── API ────────────────────────────────────────────────────────────────────

  Future<void> _loadQuestions() async {
    try {
      final uri = Uri.parse('$kBaseUrl/questions');
      final res = await http.get(uri).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final d = jsonDecode(res.body);
        final diseases = (d['diseases'] as List)
            .map((q) => _SuggestedQuestion.fromJson(q)).toList();
        final pests = (d['pests'] as List)
            .map((q) => _SuggestedQuestion.fromJson(q)).toList();
        setState(() {
          _allDiseases     = diseases;
          _allPests        = pests;
          _previewDiseases = diseases.take(3).toList();
          _previewPests    = pests.take(3).toList();
        });
      }
    } catch (_) {}
  }

  Future<void> _sendQuestion(String q) async {
    if (q.trim().isEmpty) return;
    _controller.clear();
    if (_showWelcome) setState(() => _showWelcome = false);

    setState(() {
      _messages.add(_ChatMessage(
          text: q, sender: _Sender.user, timestamp: DateTime.now()));
      _isTyping = true;
    });
    _scrollDown();

    try {
      final payload = _history
          .skip(math.max(0, _history.length - 4))
          .map((h) => {'question': h['question']!, 'answer': h['answer']!})
          .toList();

      final res = await http
          .post(Uri.parse('$kBaseUrl/ask'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'question': q,
            'history':  payload,
          }))
          .timeout(const Duration(seconds: 40));

      if (!mounted) return;

      if (res.statusCode != 200) {
        Map err = {};
        try { err = jsonDecode(res.body); } catch (_) {}
        throw Exception(err['detail'] ?? 'Server error ${res.statusCode}');
      }

      final data      = jsonDecode(res.body);
      final answer    = data['answer'] as String;
      final followups = (data['followup_suggestions'] as List? ?? [])
          .map((q) => _SuggestedQuestion.fromJson(q)).toList();

      _history.add({'question': q, 'answer': answer});

      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(
            text: answer, sender: _Sender.bot,
            timestamp: DateTime.now(), followups: followups));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(
            text: 'Could not connect to server.\nMake sure app.py is running at $kBaseUrl\n\n$e',
            sender: _Sender.bot, timestamp: DateTime.now(), isError: true));
      });
    }
    _scrollDown();
    _focusNode.requestFocus();
  }

  // ── Questions panel ────────────────────────────────────────────────────────

  void _openPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _QuestionsPanel(
        diseases: _allDiseases,
        pests: _allPests,
        onPick: (q) {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 200), () => _sendQuestion(q));
        },
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(children: [
          _buildHeader(),
          Expanded(child: _buildChat()),
          _buildInputArea(),
        ]),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
          color: _surface,
          border: Border(bottom: BorderSide(color: _border))),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
                color: _bgColor, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.arrow_back, color: _textMuted, size: 17),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
              color: _greenLight, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.eco, color: _greenDark, size: 17),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('AgriBot', style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w600, color: _textMain)),
            Text('Diseases & Pests', style: TextStyle(fontSize: 12, color: _textMuted)),
          ]),
        ),
        Container(width: 7, height: 7,
            decoration: const BoxDecoration(
                color: Color(0xFF4CAF50), shape: BoxShape.circle)),
      ]),
    );
  }

  // ── Chat ───────────────────────────────────────────────────────────────────

  Widget _buildChat() {
    final count = 1 + _messages.length + (_isTyping ? 1 : 0);
    return ListView.separated(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(14),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        if (i == 0) return _showWelcome ? _buildWelcomeCard() : _buildDateSep();
        final mi = i - 1;
        if (_isTyping && mi == _messages.length) return _buildTypingBubble();
        final msg = _messages[mi];
        return msg.sender == _Sender.user
            ? _buildUserBubble(msg)
            : _buildBotBubble(msg);
      },
    );
  }

  // Welcome card
  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      decoration: BoxDecoration(
          color: _greenPale,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFC8E6A0))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_greetPeriod(), style: const TextStyle(fontSize: 10,
            fontWeight: FontWeight.w700, color: _green, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        const Text('Good to see you!', style: TextStyle(fontSize: 20,
            fontWeight: FontWeight.w600, color: _textMain, height: 1.3)),
        const SizedBox(height: 4),
        const Text('Ask me about crop diseases or pests.',
            style: TextStyle(fontSize: 14, color: _textMuted, height: 1.6)),
        const SizedBox(height: 12),

        if (_previewDiseases.isNotEmpty || _previewPests.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Divider(color: _border, height: 1),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.tips_and_updates, size: 13, color: _textHint),
            const SizedBox(width: 5),
            const Text('Quick questions', style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: _textHint, letterSpacing: 0.5)),
            const SizedBox(width: 6),
            const Expanded(child: Divider(color: _border, height: 1)),
          ]),
          const SizedBox(height: 10),

          if (_previewDiseases.isNotEmpty)
            _chipRow('Diseases', _previewDiseases, 'disease'),
          if (_previewPests.isNotEmpty) ...[
            const SizedBox(height: 8),
            _chipRow('Pests', _previewPests, 'pest'),
          ],

          const SizedBox(height: 12),
          GestureDetector(
            onTap: _openPanel,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _borderMid)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.search, size: 15, color: _green),
                const SizedBox(width: 6),
                const Text('Browse all questions',
                    style: TextStyle(fontSize: 13, color: _green,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ] else ...[
          const SizedBox(height: 14),
          Row(children: const [
            SizedBox(width: 14, height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: _green)),
            SizedBox(width: 10),
            Text('Loading questions...', style: TextStyle(fontSize: 13, color: _textMuted)),
          ]),
        ],
      ]),
    );
  }

  Widget _chipRow(String label, List<_SuggestedQuestion> items, String cat) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: const TextStyle(fontSize: 9,
          fontWeight: FontWeight.w700, color: _textHint, letterSpacing: 0.9)),
      const SizedBox(height: 6),
      Wrap(spacing: 6, runSpacing: 6,
          children: items.map((q) => _QuestionChip(
              label: q.question, category: cat,
              onTap: () => _sendQuestion(q.question))).toList()),
    ]);
  }

  Widget _buildDateSep() {
    return Row(children: [
      const Expanded(child: Divider(color: _border)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(_fmtDate(DateTime.now()),
              style: const TextStyle(fontSize: 11, color: _textHint))),
      const Expanded(child: Divider(color: _border)),
    ]);
  }

  // User bubble — updated color
  Widget _buildUserBubble(_ChatMessage msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
              color: _userBubble,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14), bottomRight: Radius.circular(4))),
          child: Text(msg.text, style: const TextStyle(
              fontSize: 15, color: Colors.white, height: 1.6)),
        ),
        const SizedBox(height: 3),
        Text(_fmtTime(msg.timestamp),
            style: const TextStyle(fontSize: 11, color: _textHint)),
      ]),
    );
  }

  // Bot bubble
  Widget _buildBotBubble(_ChatMessage msg) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.88),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
              color: msg.isError ? _dBg : _surface,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14), bottomLeft: Radius.circular(4)),
              border: Border.all(color: msg.isError ? _dBorder : _border)),
          child: Text(msg.text, style: TextStyle(fontSize: 15,
              color: msg.isError ? _dText : _textMain, height: 1.7)),
        ),
        const SizedBox(height: 3),
        Text(_fmtTime(msg.timestamp),
            style: const TextStyle(fontSize: 11, color: _textHint)),

        if (msg.followups.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text('You might also want to ask:',
              style: TextStyle(fontSize: 12, color: _textHint)),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6,
              children: msg.followups.map((q) => _QuestionChip(
                  label: q.question, category: q.category,
                  onTap: () => _sendQuestion(q.question))).toList()),
        ],
      ]),
    );
  }

  // Typing dots
  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(color: _surface,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14), topRight: Radius.circular(14),
                bottomRight: Radius.circular(14), bottomLeft: Radius.circular(4)),
            border: Border.all(color: _border)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => AnimatedBuilder(
            animation: _dotAnim,
            builder: (_, __) {
              final offset =
                  math.sin((_dotAnim.value * 2 * math.pi) - (i * 0.36)) * 4.0;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: 7, height: 7,
                decoration: BoxDecoration(
                    color: _textHint.withOpacity(
                        0.5 + 0.5 * math.max(0, -offset / 4)),
                    shape: BoxShape.circle),
                transform: Matrix4.translationValues(0, offset, 0),
              );
            },
          )),
        ),
      ),
    );
  }

  // ── Input area ──────────────────────────────────────────────────────────────

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
          color: _surface, border: Border(top: BorderSide(color: _border))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [

        // 🔍 Browse button
        GestureDetector(
          onTap: _openPanel,
          child: Container(
            width: 44, height: 44,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
                color: _greenLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFC0DD97))),
            child: const Icon(Icons.search, color: _greenDark, size: 20),
          ),
        ),

        // Text field
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 120),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: null,
              style: const TextStyle(fontSize: 15, color: _textMain),
              decoration: InputDecoration(
                hintText: 'Type your question...',
                hintStyle: const TextStyle(fontSize: 15, color: _textHint),
                filled: true, fillColor: _bgColor,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _borderMid)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _borderMid)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF5A9E20), width: 1.5)),
              ),
              onSubmitted: (v) => _sendQuestion(v.trim()),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // ✉️ Send button
        GestureDetector(
          onTap: _isTyping ? null : () => _sendQuestion(_controller.text.trim()),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44, height: 44,
            decoration: BoxDecoration(
                color: _isTyping ? const Color(0xFFCCCCCC) : _userBubble,
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.send, color: Colors.white, size: 18),
          ),
        ),
      ]),
    );
  }
}

// ─── Question chip ─────────────────────────────────────────────────────────────

class _QuestionChip extends StatefulWidget {
  final String label, category;
  final VoidCallback onTap;
  const _QuestionChip({required this.label, required this.category, required this.onTap});
  @override
  State<_QuestionChip> createState() => _QuestionChipState();
}

class _QuestionChipState extends State<_QuestionChip> {
  bool _pressed = false;
  Color get _bg {
    if (widget.category == 'disease') return _pressed ? const Color(0xFFFFE4E4) : _dBg;
    if (widget.category == 'pest')    return _pressed ? const Color(0xFFFFEDD5) : _pBg;
    return _pressed ? _greenLight : Colors.white;
  }
  Color get _fg {
    if (widget.category == 'disease') return _dText;
    if (widget.category == 'pest')    return _pText;
    return _pressed ? _greenDark : _textMain;
  }
  Color get _bd {
    if (widget.category == 'disease') return _pressed ? const Color(0xFFE08080) : _dBorder;
    if (widget.category == 'pest')    return _pressed ? const Color(0xFFE0A040) : _pBorder;
    return _pressed ? const Color(0xFF97C459) : _borderMid;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: _bd)),
        child: Text(widget.label,
            style: TextStyle(fontSize: 13, color: _fg, height: 1.4)),
      ),
    );
  }
}

// ─── Questions bottom sheet ────────────────────────────────────────────────────

class _QuestionsPanel extends StatefulWidget {
  final List<_SuggestedQuestion> diseases, pests;
  final void Function(String) onPick;
  const _QuestionsPanel(
      {required this.diseases, required this.pests, required this.onPick});
  @override
  State<_QuestionsPanel> createState() => _QuestionsPanelState();
}

class _QuestionsPanelState extends State<_QuestionsPanel> {
  String _search = '';
  List<_SuggestedQuestion> get _fd => widget.diseases.where((q) =>
  _search.isEmpty || q.question.toLowerCase().contains(_search) ||
      q.topic.toLowerCase().contains(_search)).toList();
  List<_SuggestedQuestion> get _fp => widget.pests.where((q) =>
  _search.isEmpty || q.question.toLowerCase().contains(_search) ||
      q.topic.toLowerCase().contains(_search)).toList();

  @override
  Widget build(BuildContext context) {
    final fd = _fd; final fp = _fp;
    return Container(
      decoration: const BoxDecoration(color: _surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      child: Column(children: [
        Container(margin: const EdgeInsets.only(top: 12),
            width: 36, height: 4,
            decoration: BoxDecoration(
                color: _borderMid, borderRadius: BorderRadius.circular(2))),
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 12, 18, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Browse all questions', style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w600, color: _textMain)),
            SizedBox(height: 2),
            Text('Tap any question to ask it',
                style: TextStyle(fontSize: 13, color: _textMuted)),
          ]),
        ),
        const Divider(height: 1, color: _border),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: TextField(
            autofocus: true,
            style: const TextStyle(fontSize: 14, color: _textMain),
            decoration: InputDecoration(
              hintText: 'Search questions...',
              hintStyle: const TextStyle(fontSize: 14, color: _textHint),
              filled: true, fillColor: _bgColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              prefixIcon: const Icon(Icons.search, size: 18, color: _textHint),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _borderMid)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _borderMid)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF5A9E20), width: 1.5)),
            ),
            onChanged: (v) => setState(() => _search = v.toLowerCase().trim()),
          ),
        ),
        Expanded(
          child: fd.isEmpty && fp.isEmpty
              ? const Center(child: Text('No matching questions found',
              style: TextStyle(fontSize: 13, color: _textHint)))
              : ListView(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            children: [
              if (fd.isNotEmpty) ...[
                _sectionLabel('Diseases'),
                Wrap(spacing: 7, runSpacing: 7,
                    children: fd.map((q) => _QuestionChip(
                        label: q.question, category: 'disease',
                        onTap: () => widget.onPick(q.question))).toList()),
              ],
              if (fp.isNotEmpty) ...[
                _sectionLabel('Pests'),
                Wrap(spacing: 7, runSpacing: 7,
                    children: fp.map((q) => _QuestionChip(
                        label: q.question, category: 'pest',
                        onTap: () => widget.onPick(q.question))).toList()),
              ],
            ],
          ),
        ),
      ]),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Row(children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 11,
            fontWeight: FontWeight.w700, color: _textHint, letterSpacing: 1.0)),
        const SizedBox(width: 6),
        const Expanded(child: Divider(color: _border, height: 1)),
      ]),
    );
  }
}
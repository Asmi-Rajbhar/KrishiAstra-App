// agribot_chat_page.dart — AgriBot Flutter page v10
// Fixes:
// 1. Language change resets page completely (pushReplacement)
// 2. Questions loaded only from Frappe
// 3. No hardcoded questions

import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String kBaseUrl = 'https://safarnxma-agribot-backend.hf.space';

// ─── Language config ──────────────────────────────────────────────────────────

class _Language {
  final String code;
  final String label;
  final String greetMorning;
  final String greetAfternoon;
  final String greetEvening;
  final String welcomeTitle;
  final String welcomeSubtitle;
  final String quickQuestions;
  final String browseAll;
  final String diseases;
  final String pests;
  final String typeHint;
  final String loadingQuestions;
  final String youMightAsk;
  final String searching;
  final String noMatch;
  final String browseAllQuestions;
  final String tapToAsk;
  final String serverError;

  const _Language({
    required this.code,
    required this.label,
    required this.greetMorning,
    required this.greetAfternoon,
    required this.greetEvening,
    required this.welcomeTitle,
    required this.welcomeSubtitle,
    required this.quickQuestions,
    required this.browseAll,
    required this.diseases,
    required this.pests,
    required this.typeHint,
    required this.loadingQuestions,
    required this.youMightAsk,
    required this.searching,
    required this.noMatch,
    required this.browseAllQuestions,
    required this.tapToAsk,
    required this.serverError,
  });
}

const List<_Language> kLanguages = [
  _Language(
    code: 'marathi',
    label: 'मराठी',
    greetMorning: 'सुप्रभात',
    greetAfternoon: 'शुभ दुपार',
    greetEvening: 'शुभ संध्याकाळ',
    welcomeTitle: 'नमस्कार! आपले स्वागत आहे.',
    welcomeSubtitle: 'पिकांचे रोग किंवा कीटकांबद्दल विचारा.',
    quickQuestions: 'त्वरित प्रश्न',
    browseAll: 'सर्व प्रश्न पहा',
    diseases: 'रोग',
    pests: 'कीटक',
    typeHint: 'आपला प्रश्न टाइप करा...',
    loadingQuestions: 'प्रश्न लोड होत आहेत...',
    youMightAsk: 'आपण हे देखील विचारू शकता:',
    searching: 'प्रश्न शोधा...',
    noMatch: 'कोणताही जुळणारा प्रश्न सापडला नाही',
    browseAllQuestions: 'सर्व प्रश्न ब्राउझ करा',
    tapToAsk: 'कोणताही प्रश्न विचारण्यासाठी टॅप करा',
    serverError: 'सर्व्हरशी कनेक्ट होता आले नाही.',
  ),
  _Language(
    code: 'english',
    label: 'English',
    greetMorning: 'MORNING',
    greetAfternoon: 'AFTERNOON',
    greetEvening: 'EVENING',
    welcomeTitle: 'Good to see you!',
    welcomeSubtitle: 'Ask me about crop diseases or pests.',
    quickQuestions: 'Quick questions',
    browseAll: 'Browse all questions',
    diseases: 'Diseases',
    pests: 'Pests',
    typeHint: 'Type your question...',
    loadingQuestions: 'Loading questions...',
    youMightAsk: 'You might also want to ask:',
    searching: 'Search questions...',
    noMatch: 'No matching questions found',
    browseAllQuestions: 'Browse all questions',
    tapToAsk: 'Tap any question to ask it',
    serverError: 'Could not connect to server.',
  ),
  _Language(
    code: 'hindi',
    label: 'हिंदी',
    greetMorning: 'सुप्रभात',
    greetAfternoon: 'शुभ दोपहर',
    greetEvening: 'शुभ संध्या',
    welcomeTitle: 'नमस्ते! आपका स्वागत है।',
    welcomeSubtitle: 'फसल के रोगों या कीटों के बारे में पूछें।',
    quickQuestions: 'त्वरित प्रश्न',
    browseAll: 'सभी प्रश्न देखें',
    diseases: 'रोग',
    pests: 'कीट',
    typeHint: 'अपना प्रश्न टाइप करें...',
    loadingQuestions: 'प्रश्न लोड हो रहे हैं...',
    youMightAsk: 'आप यह भी पूछ सकते हैं:',
    searching: 'प्रश्न खोजें...',
    noMatch: 'कोई मिलते-जुलते प्रश्न नहीं मिले',
    browseAllQuestions: 'सभी प्रश्न देखें',
    tapToAsk: 'पूछने के लिए किसी प्रश्न पर टैप करें',
    serverError: 'सर्वर से कनेक्ट नहीं हो सका।',
  ),
  _Language(
    code: 'kannada',
    label: 'ಕನ್ನಡ',
    greetMorning: 'ಶುಭೋದಯ',
    greetAfternoon: 'ಶುಭ ಮಧ್ಯಾಹ್ನ',
    greetEvening: 'ಶುಭ ಸಂಜೆ',
    welcomeTitle: 'ನಮಸ್ಕಾರ! ಸ್ವಾಗತ.',
    welcomeSubtitle: 'ಬೆಳೆ ರೋಗಗಳು ಅಥವಾ ಕೀಟಗಳ ಬಗ್ಗೆ ಕೇಳಿ.',
    quickQuestions: 'ತ್ವರಿತ ಪ್ರಶ್ನೆಗಳು',
    browseAll: 'ಎಲ್ಲಾ ಪ್ರಶ್ನೆಗಳನ್ನು ನೋಡಿ',
    diseases: 'ರೋಗಗಳು',
    pests: 'ಕೀಟಗಳು',
    typeHint: 'ನಿಮ್ಮ ಪ್ರಶ್ನೆ ಟೈಪ್ ಮಾಡಿ...',
    loadingQuestions: 'ಪ್ರಶ್ನೆಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ...',
    youMightAsk: 'ನೀವು ಇದನ್ನೂ ಕೇಳಬಹುದು:',
    searching: 'ಪ್ರಶ್ನೆ ಹುಡುಕಿ...',
    noMatch: 'ಯಾವುದೇ ಹೊಂದಾಣಿಕೆ ಪ್ರಶ್ನೆ ಕಂಡುಬಂದಿಲ್ಲ',
    browseAllQuestions: 'ಎಲ್ಲಾ ಪ್ರಶ್ನೆಗಳನ್ನು ಬ್ರೌಸ್ ಮಾಡಿ',
    tapToAsk: 'ಕೇಳಲು ಯಾವುದಾದರೂ ಪ್ರಶ್ನೆ ಟ್ಯಾಪ್ ಮಾಡಿ',
    serverError: 'ಸರ್ವರ್‌ಗೆ ಸಂಪರ್ಕಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.',
  ),
  _Language(
    code: 'gujarati',
    label: 'ગુજરાતી',
    greetMorning: 'સુપ્રભાત',
    greetAfternoon: 'શુભ બપોર',
    greetEvening: 'શુભ સાંજ',
    welcomeTitle: 'નમસ્તે! આપનું સ્વાગત છે.',
    welcomeSubtitle: 'પાક રોગ અથવા જીવાત વિશે પૂછો.',
    quickQuestions: 'ઝડપી પ્રશ્નો',
    browseAll: 'બધા પ્રશ્નો જુઓ',
    diseases: 'રોગો',
    pests: 'જીવાત',
    typeHint: 'તમારો પ્રશ્ન ટાઈપ કરો...',
    loadingQuestions: 'પ્રશ્નો લોડ થઈ રહ્યા છે...',
    youMightAsk: 'તમે આ પણ પૂછી શકો છો:',
    searching: 'પ્રશ્ન શોધો...',
    noMatch: 'કોઈ મળતો પ્રશ્ન મળ્યો નથી',
    browseAllQuestions: 'બધા પ્રશ્નો બ્રાઉઝ કરો',
    tapToAsk: 'પૂછવા માટે કોઈ પ્રશ્ન ટૅપ કરો',
    serverError: 'સર્વર સાથે જોડાઈ શક્યા નહીં.',
  ),
];

_Language _langByCode(String code) =>
    kLanguages.firstWhere((l) => l.code == code, orElse: () => kLanguages.first);

// ─── Colours ──────────────────────────────────────────────────────────────────
const _green      = Color(0xFF4A8C1C);
const _greenDark  = Color(0xFF3B6D11);
const _greenLight = Color(0xFFE2F5C8);
const _greenPale  = Color(0xFFF0FADF);
const _userBubble = Color(0xFF1B6B2F);
const _bgColor    = Color(0xFFF6F6F3);
const _surface    = Color(0xFFFFFFFF);
const _border     = Color(0x14000000);
const _borderMid  = Color(0x24000000);
const _textMain   = Color(0xFF1C1C1C);
const _textMuted  = Color(0xFF6B6B6B);
const _textHint   = Color(0xFFB0B0B0);
const _dBg        = Color(0xFFFFF2F2);
const _dText      = Color(0xFF8B2020);
const _dBorder    = Color(0xFFF5BFBF);
const _pBg        = Color(0xFFFFF8ED);
const _pText      = Color(0xFF7A4800);
const _pBorder    = Color(0xFFF5D490);

// ─── Models ───────────────────────────────────────────────────────────────────
class _SuggestedQuestion {
  final String id, category, topic, question;
  const _SuggestedQuestion({
    required this.id,
    required this.category,
    required this.topic,
    required this.question,
  });
  factory _SuggestedQuestion.fromJson(Map<String, dynamic> j) =>
      _SuggestedQuestion(
        id:       j['id']       ?? '',
        category: j['category'] ?? '',
        topic:    j['topic']    ?? '',
        question: j['question'] ?? '',
      );
}

enum _Sender { user, bot }

class _ChatMessage {
  final String text;
  final _Sender sender;
  final DateTime timestamp;
  final List<_SuggestedQuestion> followups;
  final bool isError;
  const _ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
    this.followups = const [],
    this.isError = false,
  });
}

// ═════════════════════════════════════════════════════════════════════════════
// ENTRY POINT
// ═════════════════════════════════════════════════════════════════════════════

class AgribotChatPage extends StatelessWidget {
  final String initialLanguage;
  const AgribotChatPage({super.key, this.initialLanguage = 'marathi'});

  @override
  Widget build(BuildContext context) =>
      _ChatScreen(initialLanguage: initialLanguage);
}

// ═════════════════════════════════════════════════════════════════════════════
// CHAT SCREEN
// ═════════════════════════════════════════════════════════════════════════════

class _ChatScreen extends StatefulWidget {
  final String initialLanguage;
  const _ChatScreen({this.initialLanguage = 'marathi'});
  @override
  State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> with TickerProviderStateMixin {
  final List<_ChatMessage> _messages = [];
  final List<Map<String, String>> _history = [];
  bool _showWelcome = true;
  bool _isTyping    = false;

  late String _selectedLang;
  _Language get _lang => _langByCode(_selectedLang);

  List<_SuggestedQuestion> _allDiseases     = [];
  List<_SuggestedQuestion> _allPests        = [];
  List<_SuggestedQuestion> _previewDiseases = [];
  List<_SuggestedQuestion> _previewPests    = [];

  final _controller = TextEditingController();
  final _focusNode  = FocusNode();
  final _scrollCtrl = ScrollController();
  late AnimationController _dotAnim;

  @override
  void initState() {
    super.initState();
    _selectedLang = widget.initialLanguage;
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
    if (h >= 5  && h < 12) return _lang.greetMorning;
    if (h >= 12 && h < 17) return _lang.greetAfternoon;
    return _lang.greetEvening;
  }

  String _fmtTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Language change — RESETS PAGE COMPLETELY ──────────────────────────────
  // When farmer changes language, we pushReplacement with the new language.
  // This gives a completely fresh page — no old messages, no old questions.

  void _onLanguageChanged(String? newLang) {
    if (newLang == null || newLang == _selectedLang) return;
    // Replace current page with a fresh AgribotChatPage in the new language.
    // PageRouteBuilder with zero duration gives an instant refresh feel.
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) =>
            AgribotChatPage(initialLanguage: newLang),
      ),
    );
  }

  // ── API calls ──────────────────────────────────────────────────────────────

  Future<void> _loadQuestions() async {
    try {
      final uri = Uri.parse('$kBaseUrl/questions')
          .replace(queryParameters: {'language': _selectedLang});
      final res = await http.get(uri).timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        final d = jsonDecode(res.body);
        final diseases = (d['diseases'] as List)
            .map((q) => _SuggestedQuestion.fromJson(q))
            .toList();
        final pests = (d['pests'] as List)
            .map((q) => _SuggestedQuestion.fromJson(q))
            .toList();
        if (mounted) {
          setState(() {
            _allDiseases     = diseases;
            _allPests        = pests;
            _previewDiseases = diseases.take(3).toList();
            _previewPests    = pests.take(3).toList();
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _sendQuestion(String q) async {
    if (q.trim().isEmpty) return;
    _controller.clear();
    if (_showWelcome) setState(() => _showWelcome = false);

    setState(() {
      _messages.add(_ChatMessage(
        text:      q,
        sender:    _Sender.user,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });
    _scrollDown();

    try {
      final payload = _history
          .skip(math.max(0, _history.length - 4))
          .map((h) => {'question': h['question']!, 'answer': h['answer']!})
          .toList();

      final res = await http
          .post(
        Uri.parse('$kBaseUrl/ask'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': q,
          'history':  payload,
          'language': _selectedLang,
        }),
      )
          .timeout(const Duration(seconds: 60));

      if (!mounted) return;

      if (res.statusCode != 200) {
        Map err = {};
        try { err = jsonDecode(res.body); } catch (_) {}
        throw Exception(err['detail'] ?? 'Server error ${res.statusCode}');
      }

      final data      = jsonDecode(res.body);
      final answer    = data['answer'] as String;

      final _rng = math.Random();
      final _pool = List.of(_allDiseases + _allPests)..shuffle(_rng);
      final followups = _pool.take(3).toList();

      _history.add({'question': q, 'answer': answer});

      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(
          text:      answer,
          sender:    _Sender.bot,
          timestamp: DateTime.now(),
          followups: followups,
        ));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(
          text:      '${_lang.serverError}\n$kBaseUrl\n\n$e',
          sender:    _Sender.bot,
          timestamp: DateTime.now(),
          isError:   true,
        ));
      });
    }
    _scrollDown();
    _focusNode.requestFocus();
  }

  // ── Questions panel ────────────────────────────────────────────────────────

  void _openPanel() {
    showModalBottomSheet(
      context:           context,
      isScrollControlled: true,
      backgroundColor:   Colors.transparent,
      builder: (_) => _QuestionsPanel(
        diseases: _allDiseases,
        pests:    _allPests,
        lang:     _lang,
        onPick: (q) {
          Navigator.pop(context);
          Future.delayed(
            const Duration(milliseconds: 200),
                () => _sendQuestion(q),
          );
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
          color:  _surface,
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
            Text('AgriBot', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: _textMain)),
            Text('Diseases & Pests',
                style: TextStyle(fontSize: 12, color: _textMuted)),
          ]),
        ),
        Container(
            width: 7, height: 7,
            decoration: const BoxDecoration(
                color: Color(0xFF4CAF50), shape: BoxShape.circle)),
        const SizedBox(width: 10),
        _buildLanguageDropdown(),
      ]),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color:        _greenLight,
        borderRadius: BorderRadius.circular(8),
        border:       Border.all(color: const Color(0xFFC0DD97)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value:         _selectedLang,
          icon:          const Icon(Icons.language, size: 14, color: _greenDark),
          isDense:       true,
          style:         const TextStyle(
              fontSize: 13, color: _textMain, fontWeight: FontWeight.w600),
          dropdownColor: _surface,
          borderRadius:  BorderRadius.circular(10),
          onChanged:     _onLanguageChanged,
          items: kLanguages.map((lang) => DropdownMenuItem<String>(
            value: lang.code,
            child: Text(lang.label,
                style: const TextStyle(fontSize: 13, color: _textMain)),
          )).toList(),
        ),
      ),
    );
  }

  // ── Chat ───────────────────────────────────────────────────────────────────

  Widget _buildChat() {
    final count = 1 + _messages.length + (_isTyping ? 1 : 0);
    return ListView.separated(
      controller:       _scrollCtrl,
      padding:          const EdgeInsets.all(14),
      itemCount:        count,
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

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      decoration: BoxDecoration(
          color:        _greenPale,
          borderRadius: BorderRadius.circular(14),
          border:       Border.all(color: const Color(0xFFC8E6A0))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_greetPeriod(), style: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700,
            color: _green, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(_lang.welcomeTitle, style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600,
            color: _textMain, height: 1.3)),
        const SizedBox(height: 4),
        Text(_lang.welcomeSubtitle,
            style: const TextStyle(fontSize: 14, color: _textMuted, height: 1.6)),

        if (_previewDiseases.isNotEmpty || _previewPests.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Divider(color: _border, height: 1),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.tips_and_updates, size: 13, color: _textHint),
            const SizedBox(width: 5),
            Text(_lang.quickQuestions, style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: _textHint, letterSpacing: 0.5)),
            const SizedBox(width: 6),
            const Expanded(child: Divider(color: _border, height: 1)),
          ]),
          const SizedBox(height: 10),
          if (_previewDiseases.isNotEmpty)
            _chipRow(_lang.diseases, _previewDiseases, 'disease'),
          if (_previewPests.isNotEmpty) ...[
            const SizedBox(height: 8),
            _chipRow(_lang.pests, _previewPests, 'pest'),
          ],
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _openPanel,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                  color:        _surface,
                  borderRadius: BorderRadius.circular(10),
                  border:       Border.all(color: _borderMid)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.search, size: 15, color: _green),
                const SizedBox(width: 6),
                Text(_lang.browseAll, style: const TextStyle(
                    fontSize: 13, color: _green, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ] else ...[
          const SizedBox(height: 14),
          Row(children: [
            const SizedBox(width: 14, height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: _green)),
            const SizedBox(width: 10),
            Text(_lang.loadingQuestions,
                style: const TextStyle(fontSize: 13, color: _textMuted)),
          ]),
        ],
      ]),
    );
  }

  Widget _chipRow(String label, List<_SuggestedQuestion> items, String cat) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: const TextStyle(
          fontSize: 9, fontWeight: FontWeight.w700,
          color: _textHint, letterSpacing: 0.9)),
      const SizedBox(height: 6),
      Wrap(spacing: 6, runSpacing: 6,
          children: items.map((q) => _QuestionChip(
              label:    q.question,
              category: cat,
              onTap:    () => _sendQuestion(q.question))).toList()),
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

  Widget _buildUserBubble(_ChatMessage msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
              color: _userBubble,
              borderRadius: BorderRadius.only(
                  topLeft:     Radius.circular(14),
                  topRight:    Radius.circular(14),
                  bottomLeft:  Radius.circular(14),
                  bottomRight: Radius.circular(4))),
          child: Text(msg.text, style: const TextStyle(
              fontSize: 15, color: Colors.white, height: 1.6)),
        ),
        const SizedBox(height: 3),
        Text(_fmtTime(msg.timestamp),
            style: const TextStyle(fontSize: 11, color: _textHint)),
      ]),
    );
  }

  Widget _buildBotBubble(_ChatMessage msg) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.88),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
              color: msg.isError ? _dBg : _surface,
              borderRadius: const BorderRadius.only(
                  topLeft:     Radius.circular(14),
                  topRight:    Radius.circular(14),
                  bottomRight: Radius.circular(14),
                  bottomLeft:  Radius.circular(4)),
              border: Border.all(color: msg.isError ? _dBorder : _border)),
          child: Text(msg.text, style: TextStyle(
              fontSize: 15,
              color:    msg.isError ? _dText : _textMain,
              height:   1.7)),
        ),
        const SizedBox(height: 3),
        Text(_fmtTime(msg.timestamp),
            style: const TextStyle(fontSize: 11, color: _textHint)),
        if (msg.followups.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(_lang.youMightAsk,
              style: const TextStyle(fontSize: 12, color: _textHint)),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6,
              children: msg.followups.map((q) => _QuestionChip(
                  label:    q.question,
                  category: q.category,
                  onTap:    () => _sendQuestion(q.question))).toList()),
        ],
      ]),
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
            color: _surface,
            borderRadius: const BorderRadius.only(
                topLeft:     Radius.circular(14),
                topRight:    Radius.circular(14),
                bottomRight: Radius.circular(14),
                bottomLeft:  Radius.circular(4)),
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
          color:  _surface,
          border: Border(top: BorderSide(color: _border))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        GestureDetector(
          onTap: _openPanel,
          child: Container(
            width: 44, height: 44,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
                color:        _greenLight,
                borderRadius: BorderRadius.circular(10),
                border:       Border.all(color: const Color(0xFFC0DD97))),
            child: const Icon(Icons.search, color: _greenDark, size: 20),
          ),
        ),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 120),
            child: TextField(
              controller:      _controller,
              focusNode:       _focusNode,
              keyboardType:    TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines:        null,
              style: const TextStyle(fontSize: 15, color: _textMain),
              decoration: InputDecoration(
                hintText:  _lang.typeHint,
                hintStyle: const TextStyle(fontSize: 15, color: _textHint),
                filled:    true, fillColor: _bgColor,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:   const BorderSide(color: _borderMid)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:   const BorderSide(color: _borderMid)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:   const BorderSide(
                        color: Color(0xFF5A9E20), width: 1.5)),
              ),
              onSubmitted: (v) => _sendQuestion(v.trim()),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _isTyping ? null : () => _sendQuestion(_controller.text.trim()),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44, height: 44,
            decoration: BoxDecoration(
                color: _isTyping
                    ? const Color(0xFFCCCCCC)
                    : _userBubble,
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
  const _QuestionChip({
    required this.label,
    required this.category,
    required this.onTap,
  });
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
    if (widget.category == 'disease')
      return _pressed ? const Color(0xFFE08080) : _dBorder;
    if (widget.category == 'pest')
      return _pressed ? const Color(0xFFE0A040) : _pBorder;
    return _pressed ? const Color(0xFF97C459) : _borderMid;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:       widget.onTap,
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) => setState(() => _pressed = false),
      onTapCancel: ()  => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            color:        _bg,
            borderRadius: BorderRadius.circular(999),
            border:       Border.all(color: _bd)),
        child: Text(widget.label,
            style: TextStyle(fontSize: 13, color: _fg, height: 1.4)),
      ),
    );
  }
}

// ─── Questions bottom sheet ────────────────────────────────────────────────────

class _QuestionsPanel extends StatefulWidget {
  final List<_SuggestedQuestion> diseases, pests;
  final _Language lang;
  final void Function(String) onPick;
  const _QuestionsPanel({
    required this.diseases,
    required this.pests,
    required this.lang,
    required this.onPick,
  });
  @override
  State<_QuestionsPanel> createState() => _QuestionsPanelState();
}

class _QuestionsPanelState extends State<_QuestionsPanel> {
  String _search = '';

  List<_SuggestedQuestion> get _fd => widget.diseases.where((q) =>
  _search.isEmpty ||
      q.question.toLowerCase().contains(_search) ||
      q.topic.toLowerCase().contains(_search)).toList();

  List<_SuggestedQuestion> get _fp => widget.pests.where((q) =>
  _search.isEmpty ||
      q.question.toLowerCase().contains(_search) ||
      q.topic.toLowerCase().contains(_search)).toList();

  @override
  Widget build(BuildContext context) {
    final fd = _fd;
    final fp = _fp;
    return Container(
      decoration: const BoxDecoration(
          color:        _surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75),
      child: Column(children: [
        Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36, height: 4,
            decoration: BoxDecoration(
                color:        _borderMid,
                borderRadius: BorderRadius.circular(2))),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.lang.browseAllQuestions,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, color: _textMain)),
            const SizedBox(height: 2),
            Text(widget.lang.tapToAsk,
                style: const TextStyle(fontSize: 13, color: _textMuted)),
          ]),
        ),
        const Divider(height: 1, color: _border),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: TextField(
            autofocus: true,
            style: const TextStyle(fontSize: 14, color: _textMain),
            decoration: InputDecoration(
              hintText:  widget.lang.searching,
              hintStyle: const TextStyle(fontSize: 14, color: _textHint),
              filled:    true, fillColor: _bgColor,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 9),
              prefixIcon: const Icon(Icons.search, size: 18, color: _textHint),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:   const BorderSide(color: _borderMid)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:   const BorderSide(color: _borderMid)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:   const BorderSide(
                      color: Color(0xFF5A9E20), width: 1.5)),
            ),
            onChanged: (v) => setState(() => _search = v.toLowerCase().trim()),
          ),
        ),
        Expanded(
          child: fd.isEmpty && fp.isEmpty
              ? Center(child: Text(widget.lang.noMatch,
              style: const TextStyle(fontSize: 13, color: _textHint)))
              : ListView(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            children: [
              if (fd.isNotEmpty) ...[
                _sectionLabel(widget.lang.diseases),
                Wrap(spacing: 7, runSpacing: 7,
                    children: fd.map((q) => _QuestionChip(
                        label:    q.question,
                        category: 'disease',
                        onTap:    () => widget.onPick(q.question))).toList()),
              ],
              if (fp.isNotEmpty) ...[
                _sectionLabel(widget.lang.pests),
                Wrap(spacing: 7, runSpacing: 7,
                    children: fp.map((q) => _QuestionChip(
                        label:    q.question,
                        category: 'pest',
                        onTap:    () => widget.onPick(q.question))).toList()),
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
        Text(label.toUpperCase(), style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700,
            color: _textHint, letterSpacing: 1.0)),
        const SizedBox(width: 6),
        const Expanded(child: Divider(color: _border, height: 1)),
      ]),
    );
  }
}

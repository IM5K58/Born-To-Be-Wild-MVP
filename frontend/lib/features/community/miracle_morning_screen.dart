import 'package:flutter/material.dart';

class MiracleMorningScreen extends StatefulWidget {
  const MiracleMorningScreen({super.key});

  @override
  State<MiracleMorningScreen> createState() => _MiracleMorningScreenState();
}

class _MiracleMorningScreenState extends State<MiracleMorningScreen> {
  static const Color primaryColor = Color(0xFFCE4257);

  late List<Map<String, dynamic>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = [
      {
        'author': '새벽요정',
        'time': '10분 전',
        'content': '오늘도 5시 정각 인증 완료했습니다! 다들 좋은 하루 보내세요. 🔥',
        'image': null,
        'likes': 12,
        'isLiked': false,
        'comments': [
          {'author': '강철의지', 'text': '와 벌써 하셨네요! 대단합니다.'},
          {'author': '야수1호', 'text': '저도 방금 올렸습니다 ㅎㅎ'},
        ]
      },
      {
        'author': '미라클메이커',
        'time': '1시간 전',
        'content': '오늘은 눈 뜨기가 정말 힘들었네요... 그래도 찬물 세수하고 정신 차렸습니다! 아침 공부 시작합니다.',
        'image': 'https://images.unsplash.com/photo-1499750310107-5fef28a66643?q=80&w=500&auto=format&fit=crop',
        'likes': 24,
        'isLiked': true,
        'comments': [
          {'author': '열정맨', 'text': '고생하셨어요! 화이팅입니다.'},
        ]
      },
      {
        'author': '얼리버드',
        'time': '3시간 전',
        'content': '벌써 30일째 성공입니다. 보증금 덕분에 인생이 바뀌고 있어요.',
        'image': null,
        'likes': 45,
        'isLiked': false,
        'comments': []
      },
    ];
  }

  void _toggleLike(int index) {
    setState(() {
      final post = _posts[index];
      if (post['isLiked']) {
        post['likes']--;
        post['isLiked'] = false;
      } else {
        post['likes']++;
        post['isLiked'] = true;
      }
    });
  }

  void _addComment(int index, String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _posts[index]['comments'].add({
        'author': '나(야수)',
        'text': text,
      });
    });
  }

  // 글쓰기 다이얼로그
  void _showWritePostDialog() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1F25),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('새 글 작성', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '야수의 심장으로 오늘을 기록하세요...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.black.withOpacity(0.2),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.image, color: Colors.grey), onPressed: () {}),
                IconButton(icon: const Icon(Icons.camera_alt, color: Colors.grey), onPressed: () {}),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      setState(() {
                        _posts.insert(0, {
                          'author': '나(야수)',
                          'time': '방금 전',
                          'content': controller.text,
                          'image': null,
                          'likes': 0,
                          'isLiked': false,
                          'comments': [],
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: const Text('등록'),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        title: const Text('새벽 5시 미라클 모닝 팀', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F25),
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: primaryColor,
                  child: Text('🌅', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('멤버 124명 | 글 1,205개', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      const Text(
                        '매일 아침 5시, 야수의 심장으로 깨어나는 팀입니다.',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) => _PostCard(
                post: _posts[index],
                primaryColor: primaryColor,
                onLike: () => _toggleLike(index),
                onCommentAdded: (text) => _addComment(index, text),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: _showWritePostDialog,
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final Color primaryColor;
  final VoidCallback onLike;
  final Function(String) onCommentAdded;

  const _PostCard({
    required this.post,
    required this.primaryColor,
    required this.onLike,
    required this.onCommentAdded,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> comments = widget.post['comments'];
    final bool isLiked = widget.post['isLiked'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1A1F25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey[800],
                child: const Icon(Icons.person, size: 16, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              Text(widget.post['author'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 8),
              Text(widget.post['time'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const Spacer(),
              const Icon(Icons.more_vert, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.post['content'],
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          if (widget.post['image'] != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.post['image'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: widget.onLike,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: widget.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text('${widget.post['likes']}', style: TextStyle(color: widget.primaryColor, fontSize: 13, fontWeight: isLiked ? FontWeight.bold : FontWeight.normal)),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 18),
              const SizedBox(width: 4),
              Text('${comments.length}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          if (comments.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: comments.map<Widget>((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${c['author']}: ', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                      Expanded(child: Text(c['text'], style: const TextStyle(color: Colors.white70, fontSize: 12))),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: '댓글을 입력하세요...',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  widget.onCommentAdded(_commentController.text);
                  _commentController.clear();
                },
                icon: const Icon(Icons.send, color: Colors.grey, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

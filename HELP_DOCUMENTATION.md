# Help & Documentation System

## In-App Help Center

### Structure
```
Help Center (Main)
├── Getting Started
│   ├── Quick Start Guide
│   ├── First Time User Guide
│   └── Video Tutorials
├── Features
│   ├── Playing Music
│   ├── Creating Playlists
│   ├── Offline Mode
│   └── Equalizer Settings
├── Troubleshooting
│   ├── Audio Issues
│   ├── Connection Problems
│   └── Account & Login
├── FAQs
├── Contact Support
└── About Firefly
```

## Implementation

### Help Center Page
```dart
// lib/presentation/pages/help/help_center_page.dart
class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        title: Text('Help Center'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionCard(
            context,
            icon: Icons.star,
            title: 'Getting Started',
            subtitle: 'Learn the basics of Firefly',
            route: '/help/getting-started',
          ),
          _buildSectionCard(
            context,
            icon: Icons.music_note,
            title: 'Features',
            subtitle: 'Explore all features',
            route: '/help/features',
          ),
          _buildSectionCard(
            context,
            icon: Icons.warning,
            title: 'Troubleshooting',
            subtitle: 'Fix common issues',
            route: '/help/troubleshooting',
          ),
          _buildSectionCard(
            context,
            icon: Icons.question_answer,
            title: 'FAQs',
            subtitle: 'Frequently asked questions',
            route: '/help/faqs',
          ),
          _buildSectionCard(
            context,
            icon: Icons.support,
            title: 'Contact Support',
            subtitle: 'Get help from our team',
            route: '/help/support',
          ),
          _buildSectionCard(
            context,
            icon: Icons.info,
            title: 'About Firefly',
            subtitle: 'Version and legal info',
            route: '/help/about',
          ),
        ],
      ),
    );
  }
}
```

### Help Article Page
```dart
// lib/presentation/pages/help/help_article_page.dart
class HelpArticlePage extends StatelessWidget {
  final String title;
  final List<HelpSection> sections;

  HelpArticlePage({required this.title, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        title: Text(title),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return _buildHelpSection(section);
        },
      ),
    );
  }
}

class HelpSection {
  final String header;
  final String content;
  final List<String>? steps;
  final List<String>? images;

  HelpSection({
    required this.header,
    required this.content,
    this.steps,
    this.images,
  });
}
```

## Content Database

### Markdown Articles
```markdown
# Getting Started

## Quick Start

1. Open Firefly
2. Choose your music source
3. Start playing!

## Navigation

- **Library**: Your saved music
- **Search**: Find new music
- **Player**: Now playing controls

## Settings

- **Theme**: Dark/Light mode
- **Audio**: Quality and effects
- **Downloads**: Offline music
```

### HTML Articles
```html
<article class="help-article">
  <h1>Creating Playlists</h1>
  <section>
    <h2>Step 1: Add Songs</h2>
    <p>Tap the + button on any song...</p>
  </section>
</article>
```

## Help Topics

### 1. Getting Started
```dart
final gettingStartedTopics = [
  HelpTopic(
    title: 'Quick Start Guide',
    icon: Icons.flash_on,
    content: HelpContent(
      sections: [
        HelpSection(
          header: 'Welcome to Firefly',
          content: 'Firefly is a music player that lets you...',
          steps: [
            'Open the app',
            'Choose a music source',
            'Start playing tracks',
          ],
        ),
        HelpSection(
          header: 'Navigation',
          content: 'Use the bottom navigation to access...',
        ),
      ],
    ),
  ),
];
```

### 2. Features
```dart
final featureTopics = [
  HelpTopic(
    title: 'Playing Music',
    icon: Icons.play_circle,
    content: HelpContent(
      sections: [
        HelpSection(
          header: 'Basic Controls',
          content: 'Use the player controls to play, pause...',
        ),
        HelpSection(
          header: 'Queue Management',
          content: 'Reorder tracks by dragging...',
          steps: [
            'Tap and hold a track',
            'Drag to new position',
            'Release to reorder',
          ],
        ),
      ],
    ),
  ),
];
```

### 3. Troubleshooting
```dart
final troubleshootingTopics = [
  HelpTopic(
    title: 'Audio Issues',
    icon: Icons.volume_up,
    content: HelpContent(
      sections: [
        HelpSection(
          header: 'No Sound',
          content: 'If you can\'t hear audio...',
          steps: [
            'Check device volume',
            'Ensure headphones are connected',
            'Verify app permissions',
          ],
        ),
        HelpSection(
          header: 'Streaming Problems',
          content: 'If streaming is slow or stuttering...',
          steps: [
            'Check internet connection',
            'Lower audio quality in settings',
            'Restart the app',
          ],
        ),
      ],
    ),
  ),
];
```

### 4. FAQs
```dart
final faqs = [
  FAQ(
    question: 'How do I add music to my library?',
    answer: 'You can add music by...',
  ),
  FAQ(
    question: 'Can I use Firefly offline?',
    answer: 'Yes! Download songs for offline...',
  ),
  FAQ(
    question: 'How do I connect Spotify?',
    answer: 'Go to Settings > Connections...',
  ),
];
```

## Searchable Help

```dart
// lib/presentation/pages/help/help_search_page.dart
class HelpSearchPage extends SearchDelegate<HelpArticle> {
  final List<HelpArticle> articles;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = articles.where((article) {
      return article.title.toLowerCase().contains(query.toLowerCase()) ||
             article.content.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].title),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }
}
```

## Video Tutorials

```dart
// lib/presentation/pages/help/video_tutorial_page.dart
class VideoTutorialPage extends StatelessWidget {
  final List<TutorialVideo> videos = [
    TutorialVideo(
      title: 'Getting Started',
      duration: '2:30',
      thumbnail: 'assets/thumbnails/getting_started.jpg',
      videoUrl: 'https://youtube.com/watch?v=...',
    ),
    TutorialVideo(
      title: 'Creating Playlists',
      duration: '3:15',
      thumbnail: 'assets/thumbnails/playlists.jpg',
      videoUrl: 'https://youtube.com/watch?v=...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Tutorials')),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return _buildVideoCard(videos[index]);
        },
      ),
    );
  }
}
```

## Contextual Help

```dart
// Show help related to current screen
class ContextualHelpButton extends StatelessWidget {
  final String helpTopic;
  
  ContextualHelpButton({required this.helpTopic});
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.help_outline),
      onPressed: () {
        showHelpDialog(context, helpTopic);
      },
    );
  }
}

void showHelpDialog(BuildContext context, String topic) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Help: $topic'),
      content: SingleChildScrollView(
        child: Text(getHelpContent(topic)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HelpCenterPage(),
              ),
            );
          },
          child: Text('More Help'),
        ),
      ],
    ),
  );
}
```

## Support Ticket System

```dart
// lib/presentation/pages/help/support_page.dart
class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  String _subject = '';
  String _message = '';
  String _priority = 'normal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Support')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Subject'),
                onSaved: (value) => _subject = value!,
              ),
              DropdownButtonFormField<String>(
                value: _priority,
                items: ['low', 'normal', 'high', 'urgent']
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.capitalize()),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Message'),
                maxLines: 5,
                onSaved: (value) => _message = value!,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitTicket,
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Send to backend
    }
  }
}
```

## Web-Based Documentation

```dart
// lib/presentation/pages/help/web_help_page.dart
class WebHelpPage extends StatelessWidget {
  final String url;

  WebHelpPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Documentation')),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
```

## Help Analytics

```dart
// Track help usage
class HelpAnalytics {
  static void logArticleView(String articleId) {
    FirebaseAnalytics.instance.logEvent(
      name: 'help_article_view',
      parameters: {'article_id': articleId},
    );
  }

  static void logSearch(String query) {
    FirebaseAnalytics.instance.logEvent(
      name: 'help_search',
      parameters: {'search_query': query},
    );
  }

  static void logTicketCreated() {
    FirebaseAnalytics.instance.logEvent(
      name: 'support_ticket_created',
    );
  }
}
```

## Localization

```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0
```

```dart
// lib/l10n/app_en.arb
{
  "helpTitle": "Help Center",
  "quickStart": "Quick Start Guide",
  "troubleshooting": "Troubleshooting",
  "contactSupport": "Contact Support"
}
```

## Best Practices

1. **Searchable** - Full-text search across articles
2. **Visual** - Include screenshots and videos
3. **Step-by-step** - Numbered instructions for complex tasks
4. **Contextual** - Help related to current screen
5. **Offline-capable** - Cache help content
6. **Translated** - Multiple languages
7. **Updated** - Regular content updates
8. **Feedback** - Rate helpfulness
8. **Analytics** - Track what users read
8. **Accessible** - Screen reader support

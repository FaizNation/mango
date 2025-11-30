import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  Future<void> _openGitHubIssue(BuildContext context) async {
    // GitHub issue URL with pre-filled template
    final uri = Uri.parse(
      'https://github.com/FaizNation/mango/issues/new?'
      'title=${Uri.encodeComponent('[Feedback] ')}&'
      'body=${Uri.encodeComponent(_getIssueTemplate())}',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open GitHub. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getIssueTemplate() {
    return '''
## Feedback Type
<!-- Please select one: Bug Report / Feature Request / General Feedback -->

## Description
<!-- Describe your feedback here -->

## Steps to Reproduce (for bugs)
<!-- If this is a bug report, please provide steps to reproduce -->
1. 
2. 
3. 

## Expected Behavior
<!-- What did you expect to happen? -->

## Actual Behavior
<!-- What actually happened? -->

## Screenshots
<!-- If applicable, add screenshots to help explain -->

## Device Information
- Platform: <!-- Web / Android / iOS -->
- Browser (if web): 
- App Version: 

## Additional Context
<!-- Add any other context about the feedback here -->
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      appBar: AppBar(
        title: const Text('Send Feedback'),
        backgroundColor: const Color(0xFFE6F2FF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
              // Icon
              Icon(
                Icons.feedback_outlined,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'We Value Your Feedback!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Help us improve Mango by sharing your thoughts, reporting bugs, or suggesting new features.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Feedback options
              _buildFeedbackOption(
                context,
                icon: Icons.bug_report,
                title: 'Report a Bug',
                description: 'Found something that\'s not working?',
                color: Colors.red,
              ),
              const SizedBox(height: 16),

              _buildFeedbackOption(
                context,
                icon: Icons.lightbulb_outline,
                title: 'Suggest a Feature',
                description: 'Have an idea to make Mango better?',
                color: Colors.orange,
              ),
              const SizedBox(height: 16),

              _buildFeedbackOption(
                context,
                icon: Icons.chat_bubble_outline,
                title: 'General Feedback',
                description: 'Share your thoughts with us',
                color: Colors.blue,
              ),
              const SizedBox(height: 32),

              // Main button
              ElevatedButton.icon(
                onPressed: () => _openGitHubIssue(context),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open GitHub Issues'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Info text
              Text(
                'You will be redirected to GitHub to submit your feedback',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildFeedbackOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

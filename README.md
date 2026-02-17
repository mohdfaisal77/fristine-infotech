#TriviaX – Quiz Application
--------------
Overview

TriviaX is a modern Flutter-based quiz application designed to provide an engaging and interactive trivia experience. The app allows users to attempt quizzes based on different difficulty levels fetched from a real-time API. It also includes a dedicated Admin module where custom quizzes can be created and managed.

The project follows a clean architecture approach and leverages modern state management techniques to ensure scalability and maintainability.

Key Features
-----------------
1. Difficulty-Based Quiz System
   Users can choose quizzes based on:
   ->Easy
   ->Medium
   ->Hard

Custom (Admin-created)
Questions for Easy, Medium, and Hard levels are fetched dynamically from a trivia API.

Each question includes:----------
One correct answer
Three incorrect answers
Answer options are shuffled to prevent predictable patterns and ensure a dynamic experience.

2. Real-Time API Integration
-----------------------
The application integrates with an external trivia API to fetch questions dynamically. This ensures:
Fresh questions on each attempt
Dynamic quiz sessions
Non-repetitive gameplay

3. Admin Quiz Builder
-------------------
The Admin module allows administrators to:
Create up to 10 custom questions
Add four options per question
Select the correct answer
Edit existing questions
Delete questions
Persist custom questions using SharedPreferences
Custom quizzes become available to all users once created.

4. User and Admin Roles
-------------------
The application supports two roles:

->Admin
->User

Authentication is handled using SharedPreferences.
After login:
Admin users are redirected to the Admin Dashboard
Regular users are redirected to the User Dashboard

5. Intelligent Scoring System
-------------------
+10 points for each correct answer
Score deduction for skipping a question
One life deducted for each wrong answer
Quiz ends automatically when lives reach zero

6. Life-Based Gameplay
-------------------
Users start each quiz with three lives.
Each incorrect answer reduces one life
If all lives are lost, the quiz ends immediately
This creates a game-like experience rather than a traditional quiz format.

7. Visual Answer Feedback
-------------------
After selecting an option:
Correct answer appears in green
Wrong selected answer appears in red
Feedback is shown briefly before moving to the next question
This provides instant learning feedback and improves user experience.

8. Result Screen with Celebration
-------------------
At the end of the quiz:
Final score is displayed prominently
If the score exceeds a threshold, celebration animations and confetti are shown
User can return to the Home screen

9. Light and Dark Mode
-------------------
Users can toggle between Light Mode and Dark Mode.
Theme switching is handled using GetX and applied globally across the application.
Technologies Used

Frontend
--------------
Flutter
Dart

State Management
-------------
Riverpod (for quiz state and business logic)
GetX (for navigation and theme management)

Local Storage
-------------
SharedPreferences (for authentication and custom quiz persistence)

Networking
-------------
HTTP package
Trivia API integration

UI Enhancements
-------------
Lottie animations
Confetti animations
Project Architecture


The project follows a layered structure:

lib/
├── core/
│   ├── routes/
│   ├── theme/
│   └── utilities/
│
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
│
├── viewmodels/
│
└── views/
├── screens/
└── widgets/


-->>This separation ensures:
-----------------

Clean code
Better testability
Scalability for future features
How to Run the Project

Clone the repository:----
git clone <repository-url>


Navigate to the project folder:----
cd TriviaX

Install dependencies:----
flutter pub get

Run the project:----
flutter run


Make sure Flutter is installed and properly configured on your system.
Authentication Details
Users can sign up with:

Email
Password

Role (User or Admin)
Password validation includes:
Minimum length requirement
At least one number
At least one special character
Future Improvements
Possible enhancements for future versions:
Leaderboard system
Online authentication (Firebase)
Score history tracking
Timer-based quizzes
Multiplayer mode
Category-based filtering

Conclusion
----------------
TriviaX is designed as a scalable and interactive quiz platform combining real-time API data with custom admin-controlled content.


The application demonstrates:
--------------------
Modern Flutter development practices
Clean architecture
Effective state management
Role-based authentication
Polished user experience design
This project is suitable for learning purposes, portfolio demonstration, and further expansion into a production-ready quiz platform.
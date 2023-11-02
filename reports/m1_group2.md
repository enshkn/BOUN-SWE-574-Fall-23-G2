Customer Milestone 1 Deliverables
1.	Software Requirements Specification
●	Link to Project Requirements 
https://github.com/enshkn/BOUN-SWE-574-Fall-23-G2/wiki/Project-Requirements
    2. Software Design Documents
●	Link to Github Wiki Repo: 
https://github.com/enshkn/BOUN-SWE-574-Fall-23-G2/wiki/UML-Diagram
3. Scenarios and Mockups
a.	Mobile and Web App Mockups
Link to Github Wiki Repo:
https://github.com/enshkn/BOUN-SWE-574-Fall-23-G2/wiki/Mockup-Design
b.	Scenarios
●	Scenario 1
Emily's journey with the app begins as she uses it for the first time. Her app exploration experience unfolds as follows

Registration: Emily starts her journey by registering on the app. She enters her chosen username, email, and password to create her account, which is the initial step to establishing her presence on the platform.

Login: After registration, the app redirects her to the login page. Here, she logs in using her username or email and password, ensuring secure access to her account.

Home Page: Upon successful login, she lands on the home page. At this point, she observes an empty activity feed, reflecting that she hasn't followed anyone yet. 

Exploring stories: Emily's journey begins in earnest as she explores other people's stories from the "All Stories" page. Here, she can dive into diverse stories from around the world.

Interaction with Stories: While exploring stories, Emily can engage with them by adding comments or liking the ones that resonate with her. This interaction allows her to connect with authors and fellow readers who share her interests. 

Following Others: When she finds an author whose stories captivates her, Emily has the option to follow them. This ensures that she never misses an update from her favorite storytellers. 

Activity Feed: Emily can view stories from people she follows on the "Activity Feed page. "

Location-Based Exploration: If Emily wishes to discover stories related to her current location, she can explore "Nearby Stories." This feature allows her to uncover stories that align with her surroundings. 

Recommended Stories: Based on her liked stories, the app curates a "Recommended Stories" page for Emily. This ensures that she's continually exposed to fresh and engaging content.

Decades Timeline: On the "Timeline page", Emily can journey through time and explore stories based on their respective decades. This feature allows her to delve into historical narratives and gain a deeper appreciation of the past.

●	Scenario 2

Story Creation: Inspired by her travel stories, Emily decides to share her stories. She goes to the "Add Story" page and begins the creation process. She starts by crafting a compelling title, selecting relevant tags, and writing down her story.

Time Resolutions: Emily has the freedom to choose time resolutions for her story, adding a layer of depth to her narrative. Whether it's capturing the essence of a season, decade, month, specific date, or a defined time interval, she can share her journey with precision.

Geographic Details: If location plays a significant role in her story, Emily can add locations or pinpoint them on a map to provide context to her readers.

Publishing: With all the elements in place, Emily submits her story, making it available for others to explore and be inspired by.

Managing Her Stories: Emily can view, edit, or delete her stories from the "My Stories" page. This level of control ensures that her content reflects her stories accurately.
4. Project Plan, Communication Plan, Responsibility Assignment Matrix
	a.Project Plan
For the web application we decided to use Hasan Deniz’s project from last semester and improve this application with new features and enhancements. This web application uses React for front-end development. For the mobile application, we decided to develop the application with Flutter. For the backend development, again we decided to use Hasan Deniz’s project because he was the only one that used Rest Api for his project. This was important for us because we could use the same backend technology for the mobile application as well. 


	b.Communication Plan 
The first communication channel was WhatsApp, we created a WhatsApp group and added all group members. After that, we created a Discord channel and invited all group members. We conducted all group meetings from Discord. 
	c. Responsibility Assignment Matrix
Backend	Hasan Deniz, Uğur, Gökalp, Enes Hakan
Frontend Web	Tevfik, Gökalp, Görkem
Frontend Mobile	Amine, Mücahit, Görkem, Uğur
Automation	Gökalp
Recommendation System	Enes Hakan
Documentation	All members

5. Weekly reports 
Weekly reports Github Wiki Repo: 
https://github.com/enshkn/BOUN-SWE-574-Fall-23-G2/wiki/Meeting-Notes	
6.Milestone Review
a.Project Status:
	For the time being, the web application enables users to register, login, and add stories with time resolutions, multiple locations, and labels. Users can also view other people’s stories, like or comment on stories, view their own stories, and follow people and view their stories. Users can search stories based on story location, labels, titles, and decade. 
	The mobile app is created from scratch. For now, the mobile app enables users to login, register, add stories, view their own stories, and see the people’s stories that they are following. 
	For the backend development, we conjured up APIs specified for the mobile application’s technical needs, which are mainly register, login, add story, view their own stories, followed users’ stories feed and view individual stories. We have also implemented hour and minute capability, conversion from base64 to photo link in the rich text of the story, swagger implementation for better API analysis.

	b. Moving Forward
	For the web application, according to the feedback and bug detections we will add time resolution fixes, location region selection implementation, ui fixes to make both mobile and web apps to be consistent, add new features like recommended, nearby stories and timeline pages, and bug fixes like removing unnecessary information.
	For the mobile application, features that are listed in the requirement specification will be implemented one by one. For the add story feature we will add multiple location choosing, region search, and time resolution fixes. 
For the backend development, recommended stories, nearby stories, and advanced search features will be implemented.
c. Customer Feedbacks, Detected Bugs, New Requirements:
Feedbacks:
When the user creates a story, the date-time format inevitably requires the user to cover different dimensions. Therefore, improvements should be made on the existing grasping mechanism. With the improvements to be made, issues such as month-season incompatibility will be prevented and the user experience will be optimized.
In the scenario where users create a story (at the time of creation), if the user enters a location incorrectly and wants to change or delete it, the interface is expected to allow this.
After users create a story, they are expected to be able to edit that story, so the edit feature should be added.

Detected Bugs:
* In the map widget where the story location is shown, the center point should be in the middle of the area or areas where the story takes place.
* Images added to stories should be shown on the page within predetermined limits regardless of their size. User interface and experience should be optimized by adjusting the size.
* In the Story Feed section, instead of all stories, the entities to be shown should be limited by imposing a certain restriction (such as stories created in the last 7 days).

New Requirements:
* Users should be able to specify the geolocations they will add to their stories as an area by creating an area on the map.
* Duration time attribute should be added to stories expressed with a time interval.
* Timeline feature is intended to present a specific set of stories to users. For this reason, story sets should be limited by establishing some filtering mechanisms.
d. List and status of deliverables
●	Demo of mobile app is completed.
●	Demo of web app is completed.  
e. Evaluation of the status of deliverables and its impact on our project plan (reflection)
For this milestone, web and mobile applications demos were shown to the customer. Presentation started with an explanation of the approach and mindset. After that, working parts of the web and mobile app were shown. Adding a story, registering and logging in on the mobile app side, time resolution feature on the web app side was added and presented. Some bugs were discovered with the customer during this process. Newly added features like adding a picture from an external link is tested but because of the resolution problem, the planned impact is not seen. Presentation is finished with mock-ups for the parts that are planned to complete for the next milestone.

Since some of the problems occurred during the presentation, customer focused mainly on the bugs. Features that had been added were shown but the customer was waiting for a better demonstration. To have better control, recording a video of the working features was discussed among the team for the next milestone presentation. Following that, the presentation can proceed with the real life experience. Customer saw progress and transferred the expectations. After reviewing the notes taken during this presentation, new issues were created at Github accordingly. Also new requirements and changes were added on the wiki along with this report.

Customer gave feedback about the story material that had been used for the presentation. Genuine stories created by the team members will be used for the next presentation. All team members will add their authentic stories to the app as a real user and live the experience on their own. The customer stated that this is the best way to see difficulties on the user side.
f. Evaluation of Tools and Processes
Throughout the project, the tools Github, Discord, and Whatsapp are used to manage our team. The combination of these three gave us an effective team management skill. Github is a powerful tool for contribution where Discord supports communication and coordination, Whatsapp is used for mobile and effective communication and helps for quick updates.
For the Processes, Github gave the power of branching, pull requests, issue tracking, CI/CD integration, and code review. Branching eases the development organization and code integration. Pull requests ensures the code quality as it requires code reviews before merging the code with the ones in the main branch. Issues are also very helpful since it simplifies work assignment and make the team focus on priorities.
One another process management run on Discord, since it allows real time discussions, voice channels which is used very often. Real time communication helped us to make discussions and coordinate tasks. In voice channels were the places meeting held, and discussions are shaped. This communication helped the team for brainstorming and clarifying complex issues in the team.
Whatsapp is widely used for deciding the meeting times or one to one communications in the team. It is helpful for quick communication in the team.  
g.The Requirements Addressed in This Milestone
In this milestone, the team worked on most of the requirements, because they address the fundamental features and functionality of the Dutluk application. These requirements are largely about development, interaction and accessibility. The establishment of web and mobile platforms, language preference, registration and authentication processes, secure and personalized user experiences are provided in the requirements and they have met with the job. Up to this milestone, users can create and share stories, each with unique title, text content, images, locations. Interactions as follows, liking and commenting are met, and searching for stories are integrated. 
The requirements met serve the stage of the Dutluk platform, and it ensures that it mostly meets the needs and expectations, as well as it has some lacks, and needs some small changes. The detailed list of the requirements are given below.
General Requirements:
R.1.2.01: The Dutluk platform should be accessible as a web application.
R.1.2.02: The Dutluk platform should also be available as a mobile application.
R.1.2.03: The mobile app should be compatible with both iOS and Android.
R.1.2.04: The platform should be published in English for user accessibility.
User Registration and Authentication:
R.1.1.01: The homepage should include a sign-up feature for guests to create an account.
R.1.1.02: A login feature should allow users to access the application.
R.1.1.03: Users should be able to register with their email and password.
R.1.1.04: Usernames should be created during the registration process, allowing user identification.
R.1.1.05: Usernames should be unique to avoid conflicts.
R.1.1.06: Email addresses should be unique.
R.1.1.07: Users should have the ability to edit their profile information and user photo.
R.1.1.08: After registration, users should be redirected to the login page.
R.1.1.09: Users should be able to log in using their credentials.
R.1.1.10: Logging out of the application should be possible.
R.1.1.11: Incorrect login credentials should trigger an "incorrect identifier or password" error.
R.1.1.12: A user should not be able to access the application again while a session is active.
Story Creation:
R.1.1.13: Stories should be created exclusively by app users.
R.1.1.14: Users can create any number of stories.
R.1.1.15: Only users with an active session can create stories.
R.1.1.16: Users are required to provide a title for their story.
R.1.1.17: Text content for the story should be supplied by the user.
R.1.1.18: Users should be able to include image(s) in their stories.
R.1.1.19: Location of the story should be determined by the user.
R.1.1.20 to R.1.1.27: Various time resolutions should be available for specifying the story's timeline.
R.1.1.28: Users can provide location information for their stories.
R.1.1.29 and R.1.1.30: Users can assign labels and multiple labels to their stories.
R.1.1.31: Multiple location information can be associated with stories.
R.1.1.32 to R.1.1.36: Requirements related to story posts ownership, title, text content, location, and time information.
R.1.1.37: Users can unfollow other users.
R.1.1.38: Users can follow other users.
R.1.1.39: Users can like stories created by other users.
R.1.1.40: Users can comment on stories.
R.1.1.41: Users and guests can search for specific keywords on the app.
R.1.1.42: Users can add stories to their pages.
R.1.1.47 to R.1.1.50: Requirements related to commenting, liking, profile picture, and personal info.
Search and Recommendations:
R.1.1.51 to R.1.1.54: Requirements related to searching for stories based on location, date, and filtering.
R.2.1.01: Users can see when a followed user posts a story in their activity feed.
R.2.1.05: Users can search for stories based on location and distance.
R.2.1.06: Users can see stories related to followed stories, including labels, locations and dates in their recommended feed.

7. Individual Contributions
Member 1: Aminenur Dağlargüler
Responsibilities: Core member of mobile application development
Main contributions: Created mobile app mockup, create mobile application and initialization, the home page, my stories page, and add story page, log in, register, and logout functionalities.
Code-related significant issues: Issue #7,#10,#14, #20, #23, #30, #46, #50, #61, #108
Management-related significant issues: Issue #7,#10,#14, #20, #23, #30, #46, #50, #61, #108, #76, #41, #26, #23, #21, #19, #18
Pull requests: Pull requests are listed as, add story complete, Add story, story detail page, logout feature,  Development mobile, Development, Development mobile, Be-1, Implement CI/CD pipeline #13. Some of the pull requests on the development-mobile branch had a conflict with the main branch so we had to fix some of the files manually and tried to merge them again and thankfully it was resolved. When I review a pull request, I try to test the new features or fixes first and then accept the pull request. 
Member 2: Hasan Deniz Doğan
Responsibilities: Member of Backend development team
Main contributions: The full stack deployment of projects including containerization, API development suited for mobile app needs, fine-tuning and optimizing service layer. New response model designed for mobile application. Development of time resolution by updating the date resolution both in front and backend. Automatic Imgur upload feature for the photos in rich text.
Code-related significant issues: 
#19,#21,#26,#30,#34,#41,#42,#43,#44,#45,#48,#57,#63,#64,#65,#66,#76,#77,#96
Management-related significant issues: Issue #4,#8,#9,#12,#38
Pull requests: Pull Request #25,#27,#36,#45,#57,#62,#66,#67,#75,#79,#81,#96.
In our pull requests, our ci/cd pipeline runs the unit tests before the merging process so we wait for those tests to finish first, and then we review the pull requests and approve them accordingly.
Additional information: I have also fixed the bugs for add story and search functions on frontend caused by changing the date model format of backend. I also got our development branch up and running on an ec2 instance for testing purposes. Local installations for the members are also included.
Member 3: Enes Hakan İBİL
Responsibilities: Member of Backend development team specifically responsible for recommendation engine design, implementation and maintenance .
Main contributions:A literature study was conducted for the recommendation engine. Some model developments for the recommendation engine have been made and tested locally but not integrated into the system. As of Milestone 2, the recommendation engine will be implemented. . I've also reviewed the mobile development requirements
Management-related significant issues: #5, #6, #11, #12, #16, #28, #29, #31, #32, #33, #59, #83
Member 4: Şakir Tevfik Özbilgin
Responsibilities: Member of Frontend Team, to work on Web development using React
Main contributions: Starting from the very first issues, such as creating readme files or updating issues, I contributed to the GitHub basics. Then, I moved to the requirements part and discussed them with the teammates to decide, and improve its quality. After the decision to select Deniz’s project, I decided to work on the frontend, to develop the web application using React. Discussed the new UI of the web application and how the pages will be since it will be in parallel with the mobile application. To do this, I conducted some searches on React for implementation. 
Management-related significant issues: #1, #2, #3, #4, #8, #37, #48
Additional information: Contributed to milestone 1 presentation as how it will be performed and how its flow, stories, and visualizations should be.

Member 5: Gökalp Ayaz
Responsibilities: Member of Backend development, frontend development, and automation
Main contributions: I have created Azure web applications and databases. All of those resources have two instances: Test and Prod. I created ci/cd pipelines for both test and prod environments. In the current setup, whenever a new commit is made to the remote “development” branch, both frontend and backend applications are built, and tested and sonar cloud tests are executed. Provided that none of these steps failed, web apps are updated with newly created images. Whenever a commit is made to the remote “main” branch, the same steps are executed but this time prod web apps are the ones that are updated with new images.
Code-related significant issues: #13, #38, #39, #42, #45, #51, #53, #72, #74, #81
Management-related significant issues: #6

Member 6: Mücahit Uğur
Responsibilities: Member of Mobile Development
Main contributions: I've designed web mockups for the recommendation, activity, and nearby pages, ensuring they meet our project requirements. I've also reviewed the mobile development requirements and added new user stories for Milestone 1 to enhance functionality and the user experience
Management-related significant issues: #2,#23,#53
Member 7: Uğur Sevcan
Responsibilities: Member of Backend and Frontend Mobile Development
Main Contributions: I developed characters and scenarios for the milestone 1 presentation, ensuring their alignment with the requirements for effective showcasing. Additionally, I integrated user stories into the app to enhance the presentation and facilitate feedback collection on the current app version during the presentation.
Management-Related Significant Issue: #83

Member 8: M. Görkem KUYUCU
Responsibilities: Member of mobile and web frontend team
Main contributions: I finalized and demonstrated milestone 1 presentation. I joined every lesson, meeting and ensured the requirements are aligned with the customer needs. I also changed endpoints on react frontend code, which was needed to allow the app to be used in different service providers both with http and https. Finally I conducted a library search for react web to improve UI.
Code-related significant issues: #53
Management-related significant issues: #2, #4, #8
Additional information: I was also the notetaker during some of the meetings.

 
8. The Software 
	For the mobile app installation, the user simply has to download .apk file and install it. After that as a new user, you could register and login and try to add a story. You can find the .apk folder under 0.1.0-alpha pre-release on our github repository. Link: https://github.com/enshkn/BOUN-SWE-574-Fall-23-G2/releases
The web application is up and running on http://18.157.138.225:3000/
Our project contains 3 images that are created via Dockerfile for our React,js frontend and Spring Boot backend and finally the default postgres image pulled from the Docker Hub. We are able to do this via docker-compose.yml on the dutluk/ directory. The instructions for deploying the project are as follows:
-For the .env file please fill all the fields that are intentionally left blank. Please note that Imgur and Google Maps registration is necessary for api key acquisition.
POSTGRES_USER=(username)
POSTGRES_PASSWORD=(password)
POSTGRES_DB=(db name)
DUTLUK_DB_URL=(db link)
DB_USERNAME=(db username)
DB_PASSWORD=(db password)
REACT_APP_BACKEND_URL=(backend server url)
REACT_APP_FRONTEND_URL=(frontend server url)
JWT_SECRET_KEY=(random string)
REACT_APP_GOOGLE_MAPS_API_KEY=(api key acquired from Google)
TOKEN_EXPIRATION_HOUR=24
IMGUR_CLIENT_ID=(imgur api key)
-For the web application, to run the project on an ubuntu instance please refer to these commands one by one.
sudo su -
apt-get update
apt-get install docker-compose
apt-get install git
git clone https://github.com/enshkn/BOUN-SWE-574-Fall-23-G2
cd BOUN-SWE-574-Fall-23-G2/
cd dutluk/
cd dutluk_frontend/
nano .env (paste the necessary env variables here)
cd .. (return to the dutluk/ directory)
docker compose up --build -d


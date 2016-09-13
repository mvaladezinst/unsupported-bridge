# Readme

CSV in use should follow the update_existing_enrollments.csv example. Headers include, id, score, and completed_at. 

Update existing enrollments supports updating the score and completion date of learners already enrolled into a course.
It's required to pass the enrollment ID of the user, not the actual user ID. Therefore, you will need to download a 
data dump for the account and compare the user ID to the enrollment ID. You can find the enrollment ID in the enrollments.csv. 
The easiest way to compare the enrollment ID to the user ID is by using the INDEX function in excel. 

I am building a Smart Health Reminder application using Firebase as the backend. The app currently allows patients (users) to book appointments and manage their medication reminders. Now, I want to develop an admin interface for doctors with the following features:

Core Workflow
When a patient books an appointment from the user interface, the appointment data is saved in Firestore.
The doctor (admin) interface should receive a real-time notification about the new appointment (using Firestore’s real-time updates).
The doctor should be able to view, accept, or decline the appointment.
The patient should be notified of the doctor’s response.
Additional Features for the Admin Portal
Appointment Management

View all upcoming, past, and pending appointments.
Filter appointments by date, patient, or status.
Reschedule or cancel appointments with a reason.
Patient Management

View patient profiles, including basic info, medical history, and previous appointments.
Search for patients by name or ID.
Real-Time Chat

Chat with patients before or after appointments.
Send reminders or instructions directly via chat.
Prescription Management

View and update prescriptions for each patient.
Send new prescriptions or medication reminders.
Doctor Profile & Availability

Edit the doctor’s profile (name, specialty, contact info).
Set available slots for appointments so patients can only book during those times.
Notifications Center

Central place to view all notifications (new appointments, messages, cancellations).
Analytics & Reports (Optional)

View statistics such as the number of appointments, cancellations, and patient engagement.
Technical Stack
Backend: Firebase (Firestore, Authentication, Cloud Messaging)
Frontend: [Specify your framework, Flutter, etc.]
Firestore Structure Example
text

users/
  userId/
    name, email, role (user/admin), etc.

appointments/
  appointmentId/
    patientId, doctorId, date, time, status (pending/accepted/declined), notes

messages/
  chatId/
    participants: [doctorId, patientId]
    messages: [{senderId, text, timestamp}, ...]
Request
Please help me design and implement the admin portal with these features, ensuring real-time updates and a user-friendly interface for doctors.
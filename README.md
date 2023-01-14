# CLIPS_Medical_System

The code defines several templates that represent different entities, such as doctors, patients, appointments, and prescriptions. Each template has a set of slots that hold specific information about the entity. The templates include:
- `doctor`: has slots for the ID number, name, surname, room number, and phone number of the doctor.
- `patient`: has slots for the ID number, name, surname, and phone number of the patient.
- `appointment`: has slots for the doctor, patient, date, and appointment time.
- `prescription`: has a slot for the user and a multislot for the prescription.
- `room`: has slots for the room ID, current doctor, and current patient.

In addition, the code defines a set of initial facts that provide information about patients, doctors, rooms, and appointments. These facts are located in the `main_facts` rule. 

The code defines several rules, which are sets of conditions and actions that can be triggered by the system based on the facts. These rules can be used to change the current state of the system:

- `init_system_with_date`: This rule is activated when a fact `init_date` is asserted with a date and time. It then matches an appointment that has the same date and time and matches the room where the doctor for that appointment is currently located. This rule is used to initialize the system.

- `cancel_appointment`: This rule is activated when a fact `cancel_appointment` is asserted with the patient's name, surname, date and time of the appointment. 

- `move_appointment`: This rule is activated when a fact `move_appointment` is asserted with the patient's name, surname, date and time of the appointment and the new date and time.

- `new_appointment`: This rule is activated when a fact new_appointment is asserted with the patient's name, surname, date, time, and doctor's name and surname. 

- `new_prescription`: This rule is activated when a fact new_prescription is asserted with the patient's name, surname and the prescription. 

- `remove_prescription`: This rule is activated when a fact remove_prescription is asserted with the patient's name, surname and the prescription. 

- `combine_prescription`: This rule is activated when there are two prescription facts for the same patient. It then matches both prescriptions and asserts a new prescription that contains the information of the two prescriptions. The two previous prescriptions are then retracted.

- `add_urgent_patient`: This rule is activated when an urgent_patient fact is asserted. It has a salience of 100 which means that it will be executed before the other rules.

- `doctor_left_room`: This rule is activated when a doctor_left_room fact is asserted with a doctor's ID. 

- `doctor_enter_room`: This rule is activated when a doctor_enter_room fact is asserted with a doctor's ID. 

- `patient_enter_room`: This rule is activated when a patient_enter_room fact is asserted with a patient's ID and room ID. 

- `patient_left_room`: This rule is activated when a patient_left_room fact is asserted with a patient's ID. 

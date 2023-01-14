(deftemplate doctor
	(slot id_card(type STRING))
	(slot name(type STRING))
	(slot surname(type STRING))
	(slot room)
	(slot phone_number(type STRING))
)

(deftemplate patient
	(slot id_card(type STRING))
	(slot name(type STRING))
	(slot surname(type STRING))
	(slot phone_number(type STRING))
)

(deftemplate appointment
	(slot doctor)
	(slot patient)
	(slot date(type STRING))
	(slot appointment_time(type STRING))
)

(deftemplate prescription
	(slot user)
	(multislot prescription(type STRING))
)

(deftemplate room 
	(slot id)	
	(slot current_doctor) 
	(slot current_patient)
)

(deffacts main_facts
    ; ********************************
    ; Patients
    ; ********************************
	(patient
		(id_card "42888778R")
		(name "Maria") 
		(surname "Gomez")
		(phone_number "619123457")
	)

    (patient
        (id_card "42888777R")
        (name "Juan") 
        (surname "Perez")
        (phone_number "619123456")
    )
    (patient
        (id_card "44555666L")
        (name "Laura") 
        (surname "Martinez")
        (phone_number "616778899")
    )

    (patient
        (id_card "43999000L")
        (name "Antonio") 
        (surname "Hernandez")
    )

    (patient
        (id_card "45333444K")
        (name "Luis") 
        (surname "Sosa")        
    )

    ; ********************************
    ; Doctors
    ; ********************************
	(doctor (name "Antonio") (surname "Reyes") (room "A1") (phone_number "123456789") (id_card "12345678A"))
	(doctor (name "Maria") (surname "Cabrera") (room "A2") (phone_number "987654321") (id_card "12345678B"))
	(doctor (name "Luis") (surname "Garcia") (room "A3") (phone_number "111111111") (id_card "12345678C"))
	(doctor (name "Laura") (surname "Gonzalez") (room "A4") (phone_number "222222222") (id_card "12345678D"))

    ; ********************************
    ; Rooms
    ; ********************************
	(room (id "A1") (current_doctor "12345678A"))
	(room (id "A2") (current_doctor "12345678B"))
	(room (id "A3") (current_doctor "12345678C"))
	(room (id "A4") (current_doctor "12345678D"))
	
    ; ********************************
    ; Appointment
    ; ********************************
	(appointment (doctor "12345678A") (patient "42888778R") (date "2018-01-02") (appointment_time "11:00"))
	(appointment (doctor "12345678B") (patient "42888777R") (date "2018-01-02") (appointment_time "11:00"))
	(appointment (doctor "12345678C") (patient "44555666L") (date "2018-01-02") (appointment_time "11:00"))
	(appointment (doctor "12345678D") (patient "43999000L") (date "2018-01-02") (appointment_time "11:00"))
	
	(appointment (doctor "12345678A") (patient "42888778R") (date "2018-01-04") (appointment_time "10:00"))
	(appointment (doctor "12345678B") (patient "42888777R") (date "2018-01-04") (appointment_time "10:00"))
	(appointment (doctor "12345678C") (patient "44555666L") (date "2018-01-04") (appointment_time "10:00"))

	(appointment (doctor "12345678A") (patient "42888778R") (date "2018-01-05") (appointment_time "9:00"))
	(appointment (doctor "12345678B") (patient "42888777R") (date "2018-01-03") (appointment_time "12:30"))
	(appointment (doctor "12345678C") (patient "44555666L") (date "2018-01-11") (appointment_time "13:45"))

	
    ; ********************************
    ; Prescription
    ; ********************************
	(prescription (user "42888778R") (prescription "Paracetamol 500mg"))
	(prescription (user "42888777R") (prescription "Ibuprofeno 400mg" "Paracetamol 500mg"))

	(cancel_appointment "Maria" "Gomez" "2018-01-04" "10:00")
	(move_appointment "Laura" "Martinez" "2018-01-11" "13:45" "2018-01-12" "13:15")

	(init_date "2018-01-02" "11:00")
)

(defrule init_system_with_date
	(init_date ?date ?time)
	?appointment <- (appointment (doctor ?id_doctor) (patient ?id_patient) (date ?date) (appointment_time ?time))
	?room <- (room (id ?id) (current_doctor ?id_doctor))
	(patient (id_card ?id_patient) (name ?name_patient) (surname ?surname_patient))
	=> 
	(printout t "Paciente " ?name_patient " " ?surname_patient " se encuentra en la consulta " crlf)
	(modify ?room (id ?id) (current_doctor ?id_doctor) (current_patient ?id_patient))
	(retract ?appointment)
)

(defrule cancel_appointment
	?c <-(cancel_appointment  ?name  ?surname ?date ?appointment_time)
	?appointment <- (appointment (patient ?id_card) (date ?date) (appointment_time ?appointment_time))
	(patient (id_card ?id_card) (name ?name) (surname ?surname))	
	=> 
    (printout t "Cancelada la cita para  " ?name " " ?surname " el dia " ?date crlf)
    (retract ?appointment)
	(retract ?c)
)

(defrule move_appointment
	?c <-(move_appointment  ?name  ?surname ?date ?appointment_time ?new_date ?new_appointment_time)
	?appointment <- (appointment (patient ?id_card) (date ?date) (appointment_time ?appointment_time))
	(patient (id_card ?id_card) (name ?name) (surname ?surname))	
	=> 
    (printout t "Cambiada la cita para  " ?name " " ?surname " el dia " ?new_date " y hora " ?new_appointment_time crlf)
    (modify ?appointment (date ?new_date) (appointment_time ?new_appointment_time))
	(retract ?c)
)

(defrule new_appointment
	?c <-(new_appointment  ?name  ?surname ?date ?appointment_time ?doctor_name ?doctor_surname)
	?patient <- (patient (id_card ?id_card) (name ?name) (surname ?surname))	
	?doctor <- (patient (id_card ?id_doctor) (name ?doctor_name) (surname ?doctor_surname))	
	=> 
	(printout t "Nueva cita para  " ?name " " ?surname " el dia " ?date " y hora " ?appointment_time crlf)
	(assert (appointment (patient ?id_card) (doctor ?id_doctor)(date ?date) (appointment_time ?appointment_time)))
	(retract ?c)
)

(defrule new_prescription
	?c <-(new_prescription  ?name  ?surname ?prescription)
	?patient <- (patient (id_card ?id_card) (name ?name) (surname ?surname))	
	=> 
	(printout t "Nueva receta para  " ?name " " ?surname " : " ?prescription crlf)
	(assert (prescription (user ?id_card) (prescription ?prescription)))
	(retract ?c)
)

(defrule remove_prescription
	?c <-(remove_prescription  ?name  ?surname ?prescription)
	?patient <- (patient (id_card ?id_card) (name ?name) (surname ?surname))	
	?p <- (prescription (user ?id_card) (prescription $?p1 ?prescription $?p2))
	=> 
	(printout t "Receta eliminada para  " ?name " " ?surname " : " ?prescription crlf)
	(assert (prescription (user ?id_card) (prescription $?p1 $?p2)))
	(retract ?p)
	(retract ?c)
)

(defrule combine_prescription
	?p1 <- (prescription (user ?id_card) (prescription $?prescription_1))
	?p2 <- (prescription (user ?id_card) (prescription $?prescription_2))
	(test (neq $?prescription_1 $?prescription_2))
	=> 
	(printout t "Combinando prescripción " $?prescription_1 " y " $?prescription_2 crlf)
	(assert (prescription (user ?id_card) (prescription $?prescription_1 $?prescription_2)))
	(retract ?p1)
	(retract ?p2)
)

(defrule add_urgent_patient (declare (salience 100))
	?u <- (urgent_patient ?id_card ?name_patient ?surname_patient)
	?room <- (room (id ?id) (current_doctor ?id_doctor) (current_patient nil))
	?doctor <- (doctor (id_card ?id_doctor) (name ?name_doctor) (surname ?surname_doctor))
	=> 
	(printout t "Añadiendo paciente urgente " ?name_patient " " ?surname_patient " al doctor " ?name_doctor " " ?surname_doctor crlf)
	(assert (patient (id_card ?id_card) (name ?name_patient) (surname ?surname_patient)))
	(modify ?room (id ?id) (current_doctor ?id_doctor) (current_patient ?id_card))
	(retract ?u)
)

(defrule doctor_left_room
	?c <- (doctor_left_room ?id_doctor)
	?room <- (room (id ?id) (current_doctor ?id_doctor) (current_patient nil))
	?doctor <- (doctor (id_card ?id_doctor) (name ?name_doctor) (surname ?surname_doctor))
	=> 
	(printout t "Doctor " ?name_doctor " ha salido de la consulta " ?id crlf)
	(modify ?room (id ?id) (current_doctor nil) (current_patient nil))
	(retract ?c)
)

(defrule doctor_enter_room
	?c <- (doctor_enter_room ?id_doctor)
	?room <- (room (id ?id) (current_doctor nil) (current_patient nil))
	?doctor <- (doctor (id_card ?id_doctor) (name ?name_doctor) (surname ?surname_doctor))
	=> 
	(printout t "Doctor " ?name_doctor " ha entrado en la consulta " ?id crlf)
	(modify ?room (id ?id) (current_doctor ?id_doctor) (current_patient nil))
	(retract ?c)
)

(defrule patient_enter_room
	?c <- (patient_enter_room ?id_patient ?id_room)
	?room <- (room (id ?id_room) (current_doctor ?id_doctor) (current_patient nil))
	?patient <- (patient (id_card ?id_patient) (name ?name_patient) (surname ?surname_patient))
	=> 
	(printout t "Paciente " ?name_patient " " ?surname_patient " ha entrado en la consulta " ?id_room crlf)
	(modify ?room (id ?id_room) (current_doctor ?id_doctor) (current_patient ?id_patient))
	(retract ?c)
)

(defrule patient_left_room
	?c <- (patient_left_room ?id_patient)
	?room <- (room (id ?id) (current_doctor ?id_doctor) (current_patient ?id_patient))
	?patient <- (patient (id_card ?id_patient) (name ?name_patient) (surname ?surname_patient))
	=> 
	(printout t "Paciente " ?name_patient " " ?surname_patient " ha salido de la consulta " ?id crlf)
	(modify ?room (id ?id) (current_doctor ?id_doctor) (current_patient nil))	
	(printout t "Prescripcion para " ?name_patient " " ?surname_patient ":" crlf)

	(bind ?pres (readline))
	(if (neq ?pres "")
	then
		(assert (new_prescription ?name_patient ?surname_patient ?pres))
	)
	(retract ?c)
)
DROP TABLE IF EXISTS billing;
DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS patients;

CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY NOT NULL,
    age INTEGER NULL,
    gender VARCHAR NULL,
    city VARCHAR NULL,
    insurance_provider VARCHAR NULL,
    chronic_flag INTEGER NULL,
    registration_date DATE NULL
);

CREATE TABLE visits (
    visit_id INTEGER PRIMARY KEY NOT NULL,
    patient_id INTEGER NULL,
    visit_date DATE NULL,
    department VARCHAR NULL,
    visit_type VARCHAR NULL,
    length_of_stay_hours DECIMAL NULL,
    risk_score VARCHAR NULL,
    doctor_id INTEGER NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE billing (
    bill_id INTEGER PRIMARY KEY NOT NULL,
    visit_id INTEGER NULL,
    billed_amount DECIMAL NULL,
    approved_amount DECIMAL NULL,
    claim_status VARCHAR NULL,
    payment_days INTEGER NULL,
    billing_date DATE NULL,
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id)
);

-- Foreign key indexes (speeds up JOINs)
CREATE INDEX idx_visits_patient_id ON visits(patient_id);
CREATE INDEX idx_billing_visit_id ON billing(visit_id);

-- Frequently queried/filtered columns
CREATE INDEX idx_patients_city ON patients(city);
CREATE INDEX idx_patients_insurance ON patients(insurance_provider);
CREATE INDEX idx_patients_chronic ON patients(chronic_flag);
CREATE INDEX idx_visits_date ON visits(visit_date);
CREATE INDEX idx_visits_department ON visits(department);
CREATE INDEX idx_visits_type ON visits(visit_type);
CREATE INDEX idx_visits_doctor_id ON visits(doctor_id);
CREATE INDEX idx_billing_claim_status ON billing(claim_status);
CREATE INDEX idx_billing_date ON billing(billing_date);
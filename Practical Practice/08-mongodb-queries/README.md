Create MongoDB collection and insert every variety of documents
teachers : {
    name,
    age,
    qualifications,
    deptno,
    deptname,
    designation,
    experience : {
        industry,
        teaching
    },
    salary : {
        basic,
        TA,
        DA,
        HRA
    },
    date_of_joining,
    appointment_nature,
    area_of_expertise
}
package com.healthconsult.model;

/** What a patient needs to know to choose a professional. */
public class ProfessionalSummary {

    private final int id;
    private final String name;
    private final String specialization;

    public ProfessionalSummary(int id, String name, String specialization) {
        this.id = id;
        this.name = name;
        this.specialization = specialization;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getSpecialization() { return specialization; }
}

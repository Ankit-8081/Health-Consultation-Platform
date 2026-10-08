package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.model.ProfessionalSummary;
import java.util.List;
import java.util.Optional;

/** Read-only list of active healthcare professionals, for the booking page. */
public interface ProfessionalDao {

    List<ProfessionalSummary> findAllActive() throws AppException;

    Optional<ProfessionalSummary> findActiveById(int professionalId) throws AppException;
}

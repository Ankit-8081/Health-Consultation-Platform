package com.healthconsult.model;

import java.time.LocalTime;
import java.util.Objects;

/** One bookable consultation period of a day. */
public class Slot {

    private final LocalTime start;
    private final LocalTime end;

    public Slot(LocalTime start, LocalTime end) {
        this.start = start;
        this.end = end;
    }

    public LocalTime getStart() { return start; }
    public LocalTime getEnd() { return end; }

    @Override
    public boolean equals(Object o) {
        return o instanceof Slot other && start.equals(other.start) && end.equals(other.end);
    }

    @Override
    public int hashCode() { return Objects.hash(start, end); }

    @Override
    public String toString() { return start + "-" + end; }
}

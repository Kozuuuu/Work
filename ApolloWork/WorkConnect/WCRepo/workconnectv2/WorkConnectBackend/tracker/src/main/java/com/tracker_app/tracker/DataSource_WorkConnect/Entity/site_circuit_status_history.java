package com.tracker_app.tracker.DataSource_WorkConnect.Entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import lombok.Data;

@Data
@Entity
public class site_circuit_status_history {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    //private Long days_down;
    //private Long hours_down;
    
    private String site_id;
    private String circuit_type; 
    private String circuit_provider;
    private String circuit_status;
    private String circuit_ip;
    private Long minutes_down;
    private String updated_at;

    
}
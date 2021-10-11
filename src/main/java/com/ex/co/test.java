package com.ex.co;

import java.lang.System.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class test {

	@Scheduled(fixedDelay = 5000)
	public void scheduleRun() {
		System.out.println("Abs");
	}
}

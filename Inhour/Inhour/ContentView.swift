//
//  ContentView.swift
//  Inhour
//
//  Created by rijas on 17/04/25.
//
import SwiftUI

struct ContentView: View {
    @State private var hours: Int = 0
    @State private var minutes: Int = 5
    @State private var seconds: Int = 30
    @State private var isRunning: Bool = false
    @State private var timer: Timer? = nil
    @State private var totalSeconds: Int = 330 // 5 minutes and 30 seconds
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Flip Clock Timer")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                HStack(spacing: 20) {
                    // Hours
                    FlipClockCard(value: String(format: "%02d", hours))
                    
                    // Minutes
                    FlipClockCard(value: String(format: "%02d", minutes))
                    
                    // Seconds
                    FlipClockCard(value: String(format: "%02d", seconds))
                }
                .padding(.vertical, 40)
                
                HStack(spacing: 20) {
                    Button( action: {
                        if(isRunning){
                            stopTimer();
                        }else{
                            startTimer();
                        }
                    }) {
                        Text(isRunning ? "Stop" : "Start")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(isRunning ? Color.red : Color.green)
                            )
                    }
                    
                    Button(action: resetTimer) {
                        Text("Reset")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(Color.gray)
                            )
                    }
                }
                
                Spacer()
                
                HStack {
                    Text("Set Timer:")
                        .foregroundColor(.white)
                    
                    Picker("Hours", selection: $hours) {
                        ForEach(0..<24) { hour in
                            Text("\(hour) h").tag(hour)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .disabled(isRunning)
                    
                    Picker("Minutes", selection: $minutes) {
                        ForEach(0..<60) { minute in
                            Text("\(minute) m").tag(minute)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .disabled(isRunning)
                    
                    Picker("Seconds", selection: $seconds) {
                        ForEach(0..<60) { second in
                            Text("\(second) s").tag(second)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .disabled(isRunning)
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .onAppear {
            calculateTotalSeconds()
        }
        .onChange(of: hours) { _ in calculateTotalSeconds() }
        .onChange(of: minutes) { _ in calculateTotalSeconds() }
        .onChange(of: seconds) { _ in calculateTotalSeconds() }
    }
    
    func calculateTotalSeconds() {
        totalSeconds = hours * 3600 + minutes * 60 + seconds
    }
    
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if totalSeconds > 0 {
                totalSeconds -= 1
                updateTimeDisplay()
            } else {
                stopTimer()
                playAlarmSound()
            }
        }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        stopTimer()
        hours = 0
        minutes = 5
        seconds = 30
        calculateTotalSeconds()
    }
    
    func updateTimeDisplay() {
        hours = totalSeconds / 3600
        minutes = (totalSeconds % 3600) / 60
        seconds = totalSeconds % 60
    }
    
    func playAlarmSound() {
        // Code to play alarm sound when timer reaches zero
        NSSound.beep()
    }
}

struct FlipClockCard: View {
    let value: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                .background(Color.black)
                .frame(width: 120, height: 160)
            
            VStack(spacing: 0) {
                Text(value)
                    .font(.system(size: 72, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                
                // Dots in the middle
                HStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                        .padding(.horizontal, 10)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                        .padding(.horizontal, 10)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

    

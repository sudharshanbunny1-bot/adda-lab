package com.example.notes.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
public class NoteController {

    private final List<Note> notes = new ArrayList<>();

    public record Note(String title, String content, String date) {}

    public NoteController() {
        notes.add(new Note("Assignment Task", "complete your assignment", "26 Oct 2026"));
    }

    @GetMapping("/")
    public String index() {
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email, @RequestParam String password) {
        return "redirect:/notes";
    }

    @GetMapping("/notes")
    public String notes(Model model) {
        model.addAttribute("notes", notes);
        return "notes";
    }

    @PostMapping("/notes")
    public String addNote(@RequestParam String title, @RequestParam String content) {
        notes.add(new Note(title, content, "Today"));
        return "redirect:/notes";
    }
}

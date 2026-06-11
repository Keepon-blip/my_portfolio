// Intersection Observer for scroll animations
document.addEventListener("DOMContentLoaded", function () {
    const fadeElements = document.querySelectorAll(".fade-in-on-scroll");

    const observerOptions = {
        root: null, // viewport
        rootMargin: "0px",
        threshold: 0.08 // Trigger when 8% of the element is visible
    };

    const observer = new IntersectionObserver(function (entries, observer) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add("visible");
                observer.unobserve(entry.target); // Stop observing once it has animated in
            }
        });
    }, observerOptions);

    fadeElements.forEach(element => {
        // If element is already in viewport on load, show it immediately
        const rect = element.getBoundingClientRect();
        if (rect.top < window.innerHeight && rect.bottom >= 0) {
            element.classList.add("visible");
        } else {
            observer.observe(element);
        }
    });
});

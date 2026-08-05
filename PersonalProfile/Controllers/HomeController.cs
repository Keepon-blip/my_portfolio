using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using PersonalProfile.Models;

namespace PersonalProfile.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    [HttpGet("/")]
    public IActionResult Index()
    {
        return View();
    }

    [HttpGet("/about")]
    public IActionResult About()
    {
        return View();
    }

    [HttpGet("/contact")]
    public IActionResult Contact()
    {
        return View();
    }

    [HttpGet("/projects")]
    public IActionResult Projects()
    {
        return View();
    }

    [HttpGet("/resume")]
    public IActionResult Resume()
    {
        return View();
    }

    [HttpGet("/privacy")]
    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}

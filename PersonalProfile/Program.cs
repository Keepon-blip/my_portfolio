var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

var legacyRoutes = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    ["/Home/Index"] = "/",
    ["/Home/About"] = "/about",
    ["/Home/Projects"] = "/projects",
    ["/Home/Resume"] = "/resume",
    ["/Home/Contact"] = "/contact",
    ["/Home/Privacy"] = "/privacy"
};

app.Use(async (context, next) =>
{
    if (HttpMethods.IsGet(context.Request.Method) &&
        legacyRoutes.TryGetValue(context.Request.Path.Value ?? string.Empty, out var destination))
    {
        context.Response.Redirect(destination, permanent: true);
        return;
    }

    await next();
});

app.UseRouting();

app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();


app.Run();

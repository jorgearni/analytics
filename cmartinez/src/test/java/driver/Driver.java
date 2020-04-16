package driver;

import com.thoughtworks.gauge.AfterScenario;
import com.thoughtworks.gauge.AfterSuite;
import com.thoughtworks.gauge.BeforeScenario;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class Driver
{

   public static WebDriver drv;

   @BeforeScenario
    public void initializeDriver(){
       WebDriverManager.firefoxdriver().setup();
       drv = new FirefoxDriver();
    }

    // Close the webDriver instance
    @AfterScenario
    public void closeDriver(){
        drv.close();
    }

    @AfterSuite
    public void quitDriver(){
        drv.quit();
    }
}


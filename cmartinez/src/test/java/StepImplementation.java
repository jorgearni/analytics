import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import com.thoughtworks.gauge.Step;
import driver.Driver;
import org.openqa.selenium.JavascriptExecutor;
public class StepImplementation {

    @Step("Go to <relative_url> <language> <locale>")
    public void goToPage(String relativeUrl,String language, String locale) {
        String pageUrl = relativeUrl+language+locale;
        Driver.drv.get(pageUrl);
    }


    @Step("Get testdata from file <locale>")
    public void readTestData(String locale) {
        String file= "specs/data/baseData.csv";
        BufferedReader csvReader = null;
        Map<String, String> parameters=new HashMap<>();
        try
        {
            csvReader = new BufferedReader(new FileReader(file));
            String row;
            while ((row = csvReader.readLine()) != null)
            {
                String str[] = row.split("\n");
                for(int i=0;i<str.length;i++){
                    String arr[] = str[i].split(",");
                    parameters.put(arr[0], executeJavaScript(arr[0]));
                }
            }
            saveTestData(parameters,locale);

        } catch (Exception e)
        {
            e.printStackTrace();
        }

    }

        public void saveTestData(Map<String, String> parameters, String locale) {
        try{
        FileWriter fileWriter = new FileWriter("specs/data/dataValues_"+locale+".csv");
        PrintWriter printWriter = new PrintWriter(fileWriter);
        for (Map.Entry<String, String> entry : parameters.entrySet()) {
            printWriter.println(entry.getKey()+","+entry.getValue());

        }
        printWriter.close();
        } catch (Exception ex) {
            ex.printStackTrace(System.err);
        }

    }

    public String executeJavaScript(String parameter){
        JavascriptExecutor js = (JavascriptExecutor)  Driver.drv;
        String script= "return s."+parameter+".toString()";

        return (String) js.executeScript(script);

    }
}

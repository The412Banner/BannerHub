package org.json;
import java.util.Iterator;
public class JSONObject {
    public JSONObject(String json) throws JSONException {}
    public JSONObject optJSONObject(String key) { return null; }
    public JSONArray optJSONArray(String key) { return null; }
    public String optString(String key, String fallback) { return fallback; }
    public String getString(String key) throws JSONException { return ""; }
    public Iterator<String> keys() { return null; }
}

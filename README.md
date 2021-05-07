1. Install jq
2. Open the network tab in the firefox dev tools
3. Search vor "has" and click on the GET request for hasfreietermine
4. Copy the XSRF-TOKEN that is found in the Cookie of the request header and replace the text "enter token here"
5. Do the same for the text after the ; for the VWR variable
6. run the script with the Authorization token (long text) as argument. You can just copy it by right click and selecting copy, make sure you enclose the copied text with " otherwise it won't be a single argument

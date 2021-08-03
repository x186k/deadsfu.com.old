# Dead-simple Email Newsletter Signup

Hey, Cameron here, cool to see you're interested in my email newsletter
on DeadSFU, and doing amazing things with WebRTC.  
I won't share your info.  
You can unsubscribe anytime.

<script>
function validateForm() {
    let name = document.forms["myForm"]["name"].value;
    let email = document.forms["myForm"]["email"].value;
    if (email == "") {
        alert("Email must be filled out");
        return false;
    }
    const u = 'https://docs.google.com/forms/u/0/d/e/1FAIpQLSd8rzXabvn73YC_GPRtXZb1zlKPeOEQuHDdVi4m9umJqEaJsA/formResponse'
    const fo = {
        method: 'POST',
        mode: 'no-cors',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'entry.1489179593=' + name + '&emailAddress=' + email
    }

    fetch(u, fo)
        .then(r => {
            document.location = location.origin + '/newsletterthanks'
        })
        .catch(e => alert('Cannot subscribe you, please email cameron@cameronelliott.com directly. error:' + e))
    return false
}
</script>

<form name="myForm"  onsubmit="return validateForm()">
  <label for="name">Name:</label><br>
  <input type="text" id="name" name="name" placeholder="name..."><br>
  <label for="lname">Email:</label><br>
  <input type="email" id="email" name="email" value="" placeholder="foo@gmail.com"><br><br>
  <input type="submit" value="Submit">
</form>

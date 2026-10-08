for u in employee1 employee2 employee5; do
  echo "--- $u ---"

  response=$(curl -s -X POST http://localhost:8080/api/v1/auth/login \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$u@example.com\",\"password\":\"Password123!\"}")

  T=$(echo "$response" | jq -r '.data.token // empty')
  echo "TOKEN: ${T:0:20}..."

  curl -s -w "\nHTTP %{http_code}\n" http://localhost:8080/api/v1/criteria \
    -H "Authorization: Bearer $T"

  echo
done

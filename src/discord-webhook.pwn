#include <a_samp>
#include <requests>

#define WEBHOOK_URL             "https://discord.com/api/webhooks"
#define WEBHOOK_TOKEN           "1255605543448612944/D5Uask26ELk7QOcrKFTsPCRxz6UNzWVJMf7aXIfdmHZe1HM0UEcNZ1dznEPIquEcHuPZ"

static
    RequestsClient: whRequest;

main() {

}

public OnGameModeInit() {
    whRequest = RequestsClient(WEBHOOK_URL);

    SendWebhookMessage("Testando uma mensagem");
    // Roda ai primo
    return 1;
}

public OnRequestFailure(Request:id, errorCode, errorMessage[], len) {
    printf("[request error]: request id %d falhou [err %d]", _:id, errorCode);
    return 1;
}

forward OnWebhookFinished(Request:id, E_HTTP_STATUS:status, Node:node);
public OnWebhookFinished(Request:id, E_HTTP_STATUS:status, Node:node)
{
    if (!IsValidRequest(id) || !IsValidRequestsClient(whRequest)) {
        print("invalid cliente/request");
        return 0;
    }

    if (status == HTTP_STATUS_OK) {
        print("sucessful sended");
    } else {
        printf("[error OnWebhookFinished]: error id: %d", _:status);
    }
    return 1;
}

SendWebhookMessage(const message[])
{
    if (!IsValidRequestsClient(whRequest)) {
        print("invalid request id");
        return 0;
    }

    RequestJSON(
        whRequest, 
        ""WEBHOOK_TOKEN"?wait=true", 
        HTTP_METHOD_POST, 
        "OnWebhookFinished",
        JsonObject(
            "username", JsonString("Cauazinho"),
            "avatar_url", JsonString("https://i.imgur.com/yznJhMU.jpeg"),
            "content", JsonString(message),
            "allowed_mentions", JsonObject(
			    "parse", JsonArray()
			)
        ),
        RequestHeaders(
			"Content-Type", "application/json"
		)
    );
    return 1;
}

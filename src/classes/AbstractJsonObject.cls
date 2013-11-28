public virtual class AbstractJsonObject {

	public virtual override String toString() {
		return normalizeJson(JSON.serialize(this));
	}
	 	
	public static String normalizeJson(String str) {
		JSONParser parser = JSON.createParser(str);
		JSONGenerator writer = JSON.createGenerator(false);
		JSONToken token = parser.nextToken();
		String fieldName = null;
		boolean inArray = false;
		while (token != null) {
			if (token == JSONToken.START_OBJECT) {
				if (fieldName != null) {
					writer.writeFieldName(fieldName);
				}
				writer.writeStartObject();
			} else if (token == JSONToken.END_OBJECT) {
				writer.writeEndObject();
			} else if (token == JSONToken.START_ARRAY) {
				writer.writeFieldName(fieldName);
				writer.writeStartArray();
				inArray = true;
			} else if (token == JSONToken.END_ARRAY) {
				writer.writeEndArray();
				inArray = false;
			} else if (token == JSONToken.FIELD_NAME) {
				fieldName = parser.getText();
			} else if (token == JSONToken.VALUE_TRUE || token == JSONToken.VALUE_FALSE) {
				if (inArray) {
					writer.writeBoolean(parser.getBooleanValue());
				} else {
					writer.writeBooleanField(fieldName, parser.getBooleanValue());
				}
			} else if (token == JSONToken.VALUE_NULL) {
				if (inArray) {
					writer.writeNull();
				}
				//Skip null field
			} else if (token == JSONToken.VALUE_NUMBER_FLOAT) {
				if (inArray) {
					writer.writeNumber(parser.getDecimalValue());
				} else {
					writer.writeNumberField(fieldName, parser.getDecimalValue());
				}
			} else if (token == JSONToken.VALUE_NUMBER_INT) {
				if (inArray) {
					writer.writeNumber(parser.getLongValue());
				} else {
					writer.writeNumberField(fieldName, parser.getLongValue());
				}
			} else if (token == JSONToken.VALUE_STRING) {
				if (inArray) {
					writer.writeString(parser.getText());
				} else {
					writer.writeStringField(fieldName, parser.getText());
				}
			} else if (token == JSONToken.VALUE_EMBEDDED_OBJECT || token == JSONToken.NOT_AVAILABLE) {
				//Do nothing
			} else {
				throw new GoogleServiceException('Unknown token: ' + token);
			}
			token = parser.nextToken();
		}
		writer.close();
		return writer.getAsString();
	}
}
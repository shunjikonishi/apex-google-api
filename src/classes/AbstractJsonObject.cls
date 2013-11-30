public virtual class AbstractJsonObject {

	public virtual override String toString() {
		return normalizeJson(JSON.serialize(this));
	}
	 	
	public static String normalizeJson(String str) {
		JSONParser parser = JSON.createParser(str);
		JSONGenerator writer = JSON.createGenerator(false);
		JSONToken token = parser.nextToken();
		String fieldName = null;
		while (token != null) {
			if (token == JSONToken.START_OBJECT) {
				if (fieldName != null) {
					writer.writeFieldName(fieldName);
					fieldName = null;
				}
				writer.writeStartObject();
			} else if (token == JSONToken.END_OBJECT) {
				writer.writeEndObject();
			} else if (token == JSONToken.START_ARRAY) {
				writer.writeFieldName(fieldName);
				fieldName = null;
				writer.writeStartArray();
			} else if (token == JSONToken.END_ARRAY) {
				writer.writeEndArray();
			} else if (token == JSONToken.FIELD_NAME) {
				fieldName = parser.getText();
			} else if (token == JSONToken.VALUE_TRUE || token == JSONToken.VALUE_FALSE) {
				if (fieldName == null) {
					writer.writeBoolean(parser.getBooleanValue());
				} else {
					writer.writeBooleanField(fieldName, parser.getBooleanValue());
					fieldName = null;
				}
			} else if (token == JSONToken.VALUE_NULL) {
				if (fieldName == null) {
					writer.writeNull();
				} else {
					//Skip null field
					fieldName = null;
				}
			} else if (token == JSONToken.VALUE_NUMBER_FLOAT) {
				if (fieldName == null) {
					writer.writeNumber(parser.getDecimalValue());
				} else {
					writer.writeNumberField(fieldName, parser.getDecimalValue());
					fieldName = null;
				}
			} else if (token == JSONToken.VALUE_NUMBER_INT) {
				if (fieldName == null) {
					writer.writeNumber(parser.getLongValue());
				} else {
					writer.writeNumberField(fieldName, parser.getLongValue());
					fieldName = null;
				}
			} else if (token == JSONToken.VALUE_STRING) {
				if (fieldName == null) {
					writer.writeString(parser.getText());
				} else {
					writer.writeStringField(fieldName, parser.getText());
					fieldName = null;
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
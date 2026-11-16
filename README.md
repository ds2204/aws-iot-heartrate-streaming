# AWS IoT Heart-rate Streaming Prototype

An archived educational prototype prepared for maintenance under **ds2204**. The supplied materials describe Kinesis ingestion, a streaming SQL threshold, DynamoDB registration data, and a proposed serverless data-lake architecture. This is not a complete deployed system or a validated concussion detector.

## Included implementation

- [Synthetic producer](kinesis_client_HeartRate.sh): portable Bash, bounded record count and offline preview by default.
- [Legacy streaming SQL](DESTINATION_SQL_STREAM.sql): per-device 60-second average threshold example. Curly quotation syntax was removed; averaged values use a floating-point destination column.
- [DynamoDB registration example](registration.example.json): correctly named JSON rather than SQL, with fictional contact values.
- [Original architecture notes](ARCHITECTURE_HISTORY.md): preserved screenshots, references and historical walkthrough. Deployment and performance claims there are historical, not verified by this cleanup.

## Local preview

```sh
COUNT=10 bash kinesis_client_HeartRate.sh --dry-run
bash -n kinesis_client_HeartRate.sh
python3 -m json.tool registration.example.json
```

To deliberately send synthetic records to an existing stream, install AWS CLI v2, configure credentials using its normal provider chain, then run:

```sh
STREAM_NAME=your-existing-stream AWS_REGION=us-east-1 COUNT=10 bash kinesis_client_HeartRate.sh --send
```

This sends data to AWS and may incur charges. No cloud resources were created or modified during the audit. The producer uses base64 payloads explicitly and quotes the partition key. It no longer has a broken angle-bracket placeholder or depends on macOS `jot`.

## Service and implementation limitations

AWS has [discontinued Kinesis Data Analytics for SQL applications](https://docs.aws.amazon.com/kinesisanalytics/latest/dev/), with application deletion beginning January 27, 2026. The legacy SQL is preserved for study, not offered as a currently deployable service. A migration to Apache Flink would be new work and is not implemented here.

No Lambda source, Glue jobs, IAM policies, infrastructure-as-code, real sensor integration, or end-to-end tests were supplied. Streaming SQL was inspected statically; it was not executed against the discontinued service. Thresholds are illustrative, not clinically validated.

The [Apache 2.0 license](LICENSE) and [source attribution](ATTRIBUTION.md) are retained. See [AUDIT.md](AUDIT.md).

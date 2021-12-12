FROM cirrusci/flutter

WORKDIR /app/forever_note

COPY . .

CMD ["flutter run", "lib/main.dart"]
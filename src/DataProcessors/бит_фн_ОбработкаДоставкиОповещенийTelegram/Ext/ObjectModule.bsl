#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Функция определяет, что обработка является обработкой доставки оповещений.
// 
// Возвращаемое значение:
//   Булево
// 
Функция ЭтоОбработкаДоставкиОповещений() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Процедура проверяет корретность структуры сообщения. В случае ошибки устанавливается Отказ = Истина;
// 
Процедура СтруктураСообщенияКорректна(Сообщение,Отказ,ПротоколОтправки = "") Экспорт
	
	// Приведем строковое описание типа текста к системному перечислению.
	Если НЕ Сообщение.Свойство("ТипТекстаСообщения")
		ИЛИ НЕ ЗначениеЗаполнено(Сообщение.ТипТекстаСообщения) Тогда
		
		ТипТекстаСообщения = ТипТекстаПочтовогоСообщения.ПростойТекст;
	Иначе
		
		Для Каждого ТекущийТипТекста Из ТипТекстаПочтовогоСообщения Цикл
			
			Если Строка(ТекущийТипТекста) = Сообщение.ТипТекстаСообщения Тогда
				ТипТекстаСообщения = ТекущийТипТекста;
				
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Сообщение.Вставить("ТипТекстаСообщения", ТипТекстаСообщения);
	
КонецПроцедуры

// Процедура проверяет корретность настроек доставки. В случае ошибки устанавливается Отказ = Истина;
// 
Процедура СтруктураНастроекДоставкиКорректна(Настройка,Отказ,ПротоколОтправки = "") Экспорт
	
КонецПроцедуры

// Процедура проверяет корретность структуры параметров. В случае ошибки устанавливается Отказ = Истина;
// 
Процедура СтруктураПараметровКорректна(Настройка,Отказ,ПротоколОтправки = "") Экспорт
	
	Если НЕ Настройка.Свойство("АдресПолучателя") 
		 ИЛИ НЕ ЗначениеЗаполнено(Настройка.АдресПолучателя) Тогда
	
		Отказ = Истина;
		ПротоколОтправки = "Не указан чат получателя!";
		
		
	КонецЕсли; 
	
	
КонецПроцедуры

// Функция возвращает настройки доставки по умолчанию.
// 
// Возвращаемое значение:
//   РезСтруктура   - Структура
// 
Функция НастройкиПоУмолчанию() Экспорт

	РезСтруктура = Новый Структура;
	РезСтруктура.Вставить("Бот"          ,"");

	Возврат РезСтруктура;
	
КонецФункции // НастройкиПоУмолчанию()

// Процедура выполняет отправку сообщений;
// 
// Параметры:
//  СообщениеСтруктура  - Структура.
//  НастройкиДоставки   - Структура.
//  СтруктураПараметров - Структура.
//  ПротоколОтправки    - Строка.
// 
Функция ОтправитьСообщение(СообщениеСтруктура, НастройкиДоставки, СтруктураПараметров, ПротоколОтправки="") Экспорт
	
	флДействиеВыполнено = Ложь;			
	Отказ = Ложь;
	
	// Выполним проверки настроек 
	СтруктураСообщенияКорректна(СообщениеСтруктура,Отказ,ПротоколОтправки);	
	СтруктураНастроекДоставкиКорректна(НастройкиДоставки,Отказ,ПротоколОтправки); 
	СтруктураПараметровКорректна(СтруктураПараметров,Отказ,ПротоколОтправки); 
	
	Если НЕ Отказ Тогда
		
		//СообщениеЗаголовок = СтрЗаменить(СообщениеСтруктура.Заголовок,"""","\""");
		//СообщениеТекст     = СтрЗаменить(СообщениеСтруктура.Текст,"""","\""");
		
		ТекстСообщения = "<b>"+СообщениеСтруктура.Заголовок+"</b>"
		                 +Символы.ПС
						 +СообщениеСтруктура.Текст;
		
		
		// отправка оповещения
		HttpConnections = new HTTPСоединение("api.telegram.org",,,,,30,Новый ЗащищенноеСоединениеOpenSSL);
		
		HttpRequest = new HTTPЗапрос;
		
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("Content-Type","application/json");
		
		АдресРесурса = "/bot%token%/sendMessage?parse_mode=HTML&chat_id=%chatId%&text=%text%";
		АдресРесурса = СтрЗаменить(АдресРесурса, "%token%",  НастройкиДоставки.Бот.Токен);
		АдресРесурса = СтрЗаменить(АдресРесурса, "%chatId%", Формат(СтруктураПараметров.АдресПолучателя.ИД, "ЧГ="));
		АдресРесурса = СтрЗаменить(АдресРесурса, "%text%",   ТекстСообщения);
		HttpRequest.АдресРесурса = АдресРесурса;
		HttpRequest.Заголовки = Заголовки;
		
				
		//HttpRequest.УстановитьТелоИзСтроки(strJSON,КодировкаТекста.UTF8);
		
		responce = HttpConnections.ОтправитьДляОбработки(HttpRequest);
		
		strResponce = responce.ПолучитьТелоКакСтроку();
		
		Если responce.КодСостояния = 200 Тогда
			
			флДействиеВыполнено = Истина;
			
			ПротоколОтправки =  НСтр("ru = 'Сообщение отправлено в Telegram. Сообщение: %1%. Ответ сервера: %2%.'");
			ПротоколОтправки = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ПротоколОтправки, АдресРесурса, strResponce);
			
		Иначе	
			
			ПротоколОтправки =  НСтр("ru = 'Ошибка отправки сообщения в Telegram. Сообщение: %1%. Ответ сервера: %2%.'");
			ПротоколОтправки = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ПротоколОтправки, АдресРесурса, strResponce);
						
			флДействиеВыполнено = Ложь;
			
		КонецЕсли; 
		
	КонецЕсли; // Отказ
		
	Возврат флДействиеВыполнено;
	
КонецФункции


#КонецОбласти

#КонецЕсли

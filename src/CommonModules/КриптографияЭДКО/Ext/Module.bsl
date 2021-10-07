﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Криптография".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет поиска сертификата в хранилище.
Функция НайтиСертификат(Сертификат, ВыполнятьПроверку = Ложь) Экспорт
	
	НайденныйСертификат = ХранилищеСертификатов.НайтиСертификат(Сертификат);
	
	Если НайденныйСертификат <> Неопределено Тогда
		НайденныйСертификат = Новый Структура(НайденныйСертификат);
		Если ВыполнятьПроверку Тогда
			СертификатДействителен = Истина;
			Попытка
				СервисКриптографии.ПроверитьСертификат(НайденныйСертификат.Сертификат);
			Исключение
				СертификатДействителен = Ложь;
			КонецПопытки;
			НайденныйСертификат.Вставить("Валиден", СертификатДействителен);
		КонецЕсли;
		ДобавитьРеквизитыДляСовместимости(НайденныйСертификат);
	КонецЕсли;
	
	Возврат НайденныйСертификат;
	
КонецФункции

// Возвращает алгоритм зашифрованного или подписанного сообщения PKCS#7 либо сертификата X.509.
Функция АлгоритмКриптосообщенияИлиСертификата(
		КриптосообщениеИлиДанныеСертификата,
		ЭтоСертификат = Ложь,
		ЭтоСтрокаBase64 = Ложь,
		ЭтоЭлектроннаяПодписьВМоделиСервиса = Ложь) Экспорт
	
	Если НЕ ЗначениеЗаполнено(КриптосообщениеИлиДанныеСертификата) Тогда
		Результат = "";
	
	ИначеЕсли ЭтоСертификат Тогда
		Настройки = Новый Структура;
		Настройки.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса", 	ЭтоЭлектроннаяПодписьВМоделиСервиса);
		Настройки.Вставить("ЭтоСтрокаBase64", 						ЭтоСтрокаBase64);
		
		СвойстваСертификата = КриптографияЭДКОСлужебныйВызовСервера.ПолучитьСвойстваСертификата(
			КриптосообщениеИлиДанныеСертификата, Настройки);
		
		Результат = СвойстваСертификата.АлгоритмПубличногоКлюча;
		
	Иначе
		Настройки = Новый Структура;
		Настройки.Вставить("ПрочитатьПодписанныеДанные", 			Ложь);
		Настройки.Вставить("ПрочитатьИздателяИСерийныйНомер", 		Ложь);
		Настройки.Вставить("ПрочитатьАлгоритмПубличногоКлюча", 		Истина);
		Настройки.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса", 	ЭтоЭлектроннаяПодписьВМоделиСервиса);
		Настройки.Вставить("ЭтоСтрокаBase64", 						ЭтоСтрокаBase64);
		Настройки.Вставить("ВозвращатьИсключения", 					Ложь);
		
		СвойстваКриптосообщения = КриптографияЭДКОСлужебныйВызовСервера.ПолучитьСвойстваКриптосообщения(
			КриптосообщениеИлиДанныеСертификата, Настройки);
		
		Если СвойстваКриптосообщения.Тип = "EnvelopedData" И СвойстваКриптосообщения.Получатели.Количество() >= 1 Тогда
			Результат = СвойстваКриптосообщения.Получатели[0].АлгоритмПубличногоКлюча;
		ИначеЕсли СвойстваКриптосообщения.Тип = "SignedData" И СвойстваКриптосообщения.Подписанты.Количество() >= 1 Тогда
			Результат = СвойстваКриптосообщения.Подписанты[0].АлгоритмПодписи;
		Иначе
			Результат = "";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Строка(Результат);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ДобавитьРеквизитыДляСовместимости(Сертификат)
	
	ПоясСеанса = ЧасовойПоясСеанса();
	
	ДатаНачалаСертификата = Сертификат.ДатаНачала;
	Если ТипЗнч(ДатаНачалаСертификата) = Тип("Дата") Тогда
		ДатаНачалаСертификата = МестноеВремя(ДатаНачалаСертификата, ПоясСеанса);
	КонецЕсли;
	ДатаОкончанияСертификата = Сертификат.ДатаОкончания;
	Если ТипЗнч(ДатаОкончанияСертификата) = Тип("Дата") Тогда
		ДатаОкончанияСертификата = МестноеВремя(ДатаОкончанияСертификата, ПоясСеанса);
	КонецЕсли;
	
	// Поля для совместимости
	Сертификат.Вставить("ДействителенС", ДатаНачалаСертификата);
	Сертификат.Вставить("ДействителенПо", ДатаОкончанияСертификата);
	
	Сертификат.Вставить("Поставщик", КриптографияЭДКОСлужебныйВызовСервера.ПреобразоватьВСтроку(Сертификат.Издатель));
	Сертификат.Вставить("Владелец", КриптографияЭДКОСлужебныйВызовСервера.ПреобразоватьВСтроку(Сертификат.Субъект));
	
	Сертификат.Вставить("Отпечаток", НРег(СтрЗаменить(Сертификат.Отпечаток, " ", "")));
	Сертификат.СерийныйНомер = НРег(СокрЛП(Сертификат.СерийныйНомер));
	Сертификат.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса", Истина);
	
	Возврат Сертификат;
	
КонецФункции

#КонецОбласти
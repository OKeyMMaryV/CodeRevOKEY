////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборотВызовСервера: сервер, вызов сервера
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при выборе автоматической настройки интеграции по документу ПоступлениеТоваровУслуг.
// Создает правила интеграции и вид входящего документа.
//
// Возвращаемое значение:
//   Массив - ссылки на созданные правила.
//
Функция НачатьАвтоматическуюНастройкуИнтеграцииПоступлениеТоваровУслуг() Экспорт
	
	СозданныеПравила = Новый Массив;
	
	ТипДокумента = "DMIncomingDocument";
	ТипВидаДокумента = ТипДокумента + "Type";
	
	НаименованиеВидаДокумента = НСтр("ru = 'Поступление (акт, накладная)'");
	
	// Получим идентификатор вида документа из предыдущих попыток настройки.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 2
		|	ПравилаЗаполненияРеквизитовДО.ЗначениеРеквизитаДОID КАК ИдентификаторВидаДокумента
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом.ПравилаЗаполненияРеквизитовДО КАК ПравилаЗаполненияРеквизитовДО
		|ГДЕ
		|	ПравилаЗаполненияРеквизитовДО.ЗначениеРеквизитаДО = &НаименованиеВидаДокумента
		|	И ПравилаЗаполненияРеквизитовДО.ЗначениеРеквизитаДОТип = &ТипВидаДокумента
		|	И Ссылка.ТипОбъектаИС = &ТипОбъектаИС
		|");
		
	Запрос.УстановитьПараметр("НаименованиеВидаДокумента", НаименованиеВидаДокумента);
	Запрос.УстановитьПараметр("ТипВидаДокумента", ТипВидаДокумента);
	Запрос.УстановитьПараметр("ТипОбъектаИС", "Документ.ПоступлениеТоваровУслуг");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ИдентификаторВидаДокумента = Выборка.ИдентификаторВидаДокумента;
	Иначе
		ИдентификаторВидаДокумента = Неопределено;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	// Проверим, существует ли этот вид документа в подключенной базе ДО.
	Если ИдентификаторВидаДокумента <> Неопределено Тогда
		
		Попытка
			ИнтеграцияС1СДокументооборот.ПолучитьОбъект(Прокси, ТипВидаДокумента, ИдентификаторВидаДокумента);
		Исключение // ранее созданный вид документа удален или база другая
			ИдентификаторВидаДокумента = Неопределено;
		КонецПопытки;
		
	КонецЕсли;
	
	ВидДокумента = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, ТипВидаДокумента);
	ВидДокумента.objectId = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID"); 
	ВидДокумента.objectId.type = ТипВидаДокумента;
	ВидДокумента.name = НаименованиеВидаДокумента;
	
	Если ИдентификаторВидаДокумента <> Неопределено Тогда
		ВидДокумента.objectId.id = ИдентификаторВидаДокумента;
	Иначе
		ВидДокумента.objectId.id = "";
		ВидДокумента.automaticNumeration = Истина;
		ВидДокумента = ИнтеграцияС1СДокументооборот.СоздатьНовыйОбъект(Прокси, ВидДокумента).object;
	КонецЕсли;
	
	Для Каждого ВидОперации Из Перечисления.ВидыОперацийПоступлениеТоваровУслуг Цикл
	
		Правило = Справочники.ПравилаИнтеграцииС1СДокументооборотом.СоздатьЭлемент();
		Правило.ТипОбъектаИС = "Документ.ПоступлениеТоваровУслуг";
		Правило.ТипОбъектаДО = ТипДокумента;
	
		// Ключевые реквизиты, вид операции и вид документа.
		
		Реквизит = Правило.ПравилаЗаполненияРеквизитовИС.Добавить();
		Реквизит.Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.УказанноеЗначение;
		Реквизит.ИмяРеквизитаОбъектаИС = "ВидОперации";
		Реквизит.ЗначениеРеквизитаИС = ВидОперации;
		Реквизит.Ключевой = Истина;
		
		Реквизит = Правило.ПравилаЗаполненияРеквизитовДО.Добавить();
		Реквизит.Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.УказанноеЗначение;
		Реквизит.ИмяРеквизитаОбъектаДО = "documentType";
		Реквизит.ЗначениеРеквизитаДО = ВидДокумента.name;
		Реквизит.ЗначениеРеквизитаДОID = ВидДокумента.objectId.id;
		Реквизит.ЗначениеРеквизитаДОТип = ВидДокумента.objectId.type;
		Реквизит.Ключевой = Истина;
		
		// Парные правила.
		
		ДобавитьПарноеПравило(Правило, "Организация", "organization");
		ДобавитьПарноеПравило(Правило, "ВалютаДокумента", "currency");
		ДобавитьПарноеПравило(Правило, "СуммаДокумента", "sum");
		ДобавитьПарноеПравило(Правило, "Контрагент", "correspondent");
		ДобавитьПарноеПравило(Правило, "Дата", "regDate");
		ДобавитьПарноеПравило(Правило, "ПодразделениеОрганизации", "subdivision");
		ДобавитьПарноеПравило(Правило, "Комментарий", "comment");
		ДобавитьПарноеПравило(Правило, "Ответственный", "responsible");
		
		// Прочие правила. Выгрузка.
		
		Реквизит = Правило.ПравилаЗаполненияРеквизитовДО.Добавить();
		Реквизит.Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта;
		Реквизит.ИмяРеквизитаОбъектаДО = "regNumber";
		Реквизит.ИмяРеквизитаОбъектаИС = "Номер";
		Реквизит.Обновлять = Истина;
		
		Реквизит = Правило.ПравилаЗаполненияРеквизитовДО.Добавить();
		Реквизит.ИмяРеквизитаОбъектаДО = "title";
		Реквизит.Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.ВыражениеНаВстроенномЯзыке;
		Реквизит.ВычисляемоеВыражение = "Параметры.Результат = Строка(Параметры.Источник);";
		Реквизит.Обновлять = Истина;
		
		Реквизит = Правило.ПравилаЗаполненияРеквизитовДО.Добавить();
		Реквизит.ИмяРеквизитаОбъектаДО = "accessLevel";
		Реквизит.Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.ВыражениеНаВстроенномЯзыке;
		Реквизит.ВычисляемоеВыражение = "Параметры.Результат = ""Общий"";";
		
		Реквизит = Правило.ПравилаЗаполненияРеквизитовДО.Добавить();
		Реквизит.ИмяРеквизитаОбъектаДО = "activityMatter";
		Реквизит.Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.ВыражениеНаВстроенномЯзыке;
		Реквизит.ВычисляемоеВыражение = "Параметры.Результат = ""Основная деятельность"";";
		
		// Прочие правила. Загрузка.
		
		Реквизит = Правило.ПравилаЗаполненияРеквизитовИС.Добавить();
		Реквизит.Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта;
		Реквизит.ИмяРеквизитаОбъектаДО = "externalNumber";
		Реквизит.ИмяРеквизитаОбъектаИС = "НомерВходящегоДокумента";
		Реквизит.Обновлять = Истина;
		
		Реквизит = Правило.ПравилаЗаполненияРеквизитовИС.Добавить();
		Реквизит.Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта;
		Реквизит.ИмяРеквизитаОбъектаДО = "externalDate";
		Реквизит.ИмяРеквизитаОбъектаИС = "ДатаВходящегоДокумента";
		Реквизит.Обновлять = Истина;
		
		Правило.Записать();
		
		СозданныеПравила.Добавить(Правило.Ссылка);
		
	КонецЦикла;
	
	Возврат СозданныеПравила;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьПарноеПравило(Правило, ИмяРеквизитаОбъектаИС, ИмяРеквизитаОбъектаДО)
	
	Реквизит = Правило.ПравилаЗаполненияРеквизитовДО.Добавить();
	Реквизит.Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта;
	Реквизит.ИмяРеквизитаОбъектаДО = ИмяРеквизитаОбъектаДО;
	Реквизит.ИмяРеквизитаОбъектаИС = ИмяРеквизитаОбъектаИС;
	Реквизит.Обновлять = Истина;
	
	Реквизит = Правило.ПравилаЗаполненияРеквизитовИС.Добавить();
	Реквизит.Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта;
	Реквизит.ИмяРеквизитаОбъектаДО = ИмяРеквизитаОбъектаДО;
	Реквизит.ИмяРеквизитаОбъектаИС = ИмяРеквизитаОбъектаИС;
	Реквизит.Обновлять = Истина;
	
КонецПроцедуры

#КонецОбласти
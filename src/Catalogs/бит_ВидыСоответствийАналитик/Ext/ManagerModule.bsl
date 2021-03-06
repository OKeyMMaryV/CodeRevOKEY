#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Функция возвращает максимальное количество аналитик, используемое в соответствии.
// 
// Возвращаемое значение:
//  Результат - Число.
// 
Функция МаксКоличествоАналитик() Экспорт

	Возврат 3;
	
КонецФункции // МаксКоличествоАналитик()

// Процедура заполняет поля предопределенных видов соответствий.
// 
Процедура НастроитьПредопределенныеВидыСоответствий(ВыводитьСообщения = Ложь) Экспорт

	Если бит_ОбщегоНазначения.ЭтоСемействоERP() Тогда
		НастроитьПредопределенныеВидыСоответствийЕРП(ВыводитьСообщения);  		
	ИначеЕсли бит_ОбщегоНазначения.ЭтоБП() Тогда
		НастроитьПредопределенныеВидыСоответствийБП(ВыводитьСообщения);
	КонецЕсли; 

	Если ВыводитьСообщения Тогда 	
		ТекстСообщения =  НСтр("ru = 'Настроены предопределенные виды соответствий'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли; 
	
КонецПроцедуры // НастроитьПредопределенныеВидыСоответствий()

// Функция возвращает список имен, зарезервированных для фиксированных соответствий.
// 
// Возвращаемое значение:
//  Имена - Строка.
// 
Функция ЗарезервированныеИмена() Экспорт
	
	Имена = Новый СписокЗначений;
	
	флЕстьРегистр = ?(НЕ Метаданные.РегистрыСведений.Найти("бит_СтатьиОборотов_СтатьиРегл") = Неопределено, Истина, Ложь);
	
	Если флЕстьРегистр Тогда
		Имена.Добавить("Статьи_СтатьиРегл");
	КонецЕсли; 
	
	флЕстьРегистр = ?(НЕ Метаданные.РегистрыСведений.Найти("бит_СтатьиОборотов_НоменклатурныеГруппы") = Неопределено, Истина, Ложь);
	
	Если флЕстьРегистр Тогда
		Имена.Добавить("Статьи_НоменклатурныеГруппы");
	КонецЕсли; 
	
	флЕстьРегистр = ?(НЕ Метаданные.РегистрыСведений.Найти("бит_ЦФО_Подразделения") = Неопределено, Истина, Ложь);		
	
	Если флЕстьРегистр Тогда
		Имена.Добавить("ЦФО_Подразделения");
	КонецЕсли; 
	
	Возврат Имена;
	
КонецФункции // ЗарезервированныеИмена()

// Функция определяет наличие записей в РС.бит_СоответствиеАналитик.
// 
// Возвращаемое значение:
//  флЕстьЗаписи - Булево.
// 
Функция ЕстьЗаписи(ВидСоответствия) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидСоответствия", ВидСоответствия);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	бит_СоответствияАналитик.ВидСоответствия
	|ИЗ
	|	РегистрСведений.бит_СоответствияАналитик КАК бит_СоответствияАналитик
	|ГДЕ
	|	бит_СоответствияАналитик.ВидСоответствия = &ВидСоответствия";
	
	Результат = Запрос.Выполнить();
	Возврат НЕ Результат.Пустой();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьПредопределенныеВидыСоответствийБП(ВыводитьСообщения)
	
	// СтатьиОборотовБДР_СтатьиОборотовБДДС
	СпрОб = Справочники.бит_ВидыСоответствийАналитик.СтатьиОборотовБДР_СтатьиОборотовБДДС.ПолучитьОбъект();
	СпрОб.Соотношение 		= Перечисления.бит_ВидыСоотношенийАналитик.МногиеКОдному;
	СпрОб.ЛеваяАналитика_1  = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.СтатьяОборотов;
	СпрОб.ПраваяАналитика_1 = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.СтатьяОборотов;
	
	бит_ОбщегоНазначения.ЗаписатьСправочник(СпрОб, "", "Ошибки", Истина);
	
	// СтатьиОборотов_ВидыПлатежей
	СпрОб = Справочники.бит_ВидыСоответствийАналитик.СтатьиОборотов_ВидыПлатежей.ПолучитьОбъект();
	СпрОб.Соотношение 		= Перечисления.бит_ВидыСоотношенийАналитик.МногиеКОдному;
	СпрОб.ЛеваяАналитика_1  = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.СтатьяОборотов;
	СпрОб.ПраваяАналитика_1 = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.ВидыПлатежей;
	
	бит_ОбщегоНазначения.ЗаписатьСправочник(СпрОб, "", "Ошибки", Истина);
	
	// ОКЕЙ Смирнов М.В. (СофтЛаб) Начало 2021-11-07 (#4407)
	// ок_Валюта_СценарийПланирования
	СпрОб = Справочники.бит_ВидыСоответствийАналитик.ок_Валюта_СценарийПланирования.ПолучитьОбъект();
	СпрОб.Соотношение 		= Перечисления.бит_ВидыСоотношенийАналитик.ОдинКОдному;
	СпрОб.ЛеваяАналитика_1  = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.ок_Валюты;
	СпрОб.ПраваяАналитика_1 = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.ок_СценарийПланирования;
	
	бит_ОбщегоНазначения.ЗаписатьСправочник(СпрОб, "", "Ошибки", Истина);
	// ОКЕЙ Смирнов М.В. (СофтЛаб) Конец 2021-11-07 (#4407)
	
КонецПроцедуры

Процедура НастроитьПредопределенныеВидыСоответствийЕРП(ВыводитьСообщения)
	
	// Для совместимости с ЕРП.
	
КонецПроцедуры

#КонецОбласти 

#КонецЕсли

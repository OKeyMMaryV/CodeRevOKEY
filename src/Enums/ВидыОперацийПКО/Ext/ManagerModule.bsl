﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора         = ДопустимыеЗначения(Параметры.Отбор, Параметры.СтрокаПоиска);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Отбор") Тогда
		Параметры.Вставить("Отбор", Новый Структура);
	КонецЕсли;
	
	ДанныеВыбора = ДопустимыеЗначения(Параметры.Отбор);
	Параметры.Отбор.Очистить();
	Параметры.Отбор.Вставить("Ссылка", ДанныеВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Заполняет список значений данных выбора с учетом настроек учета и прав пользователя.
//
// Параметры:
//  Отбор		 - Структура - элемент параметров выбора: отбор, используемый при поиске данных
//  СтрокаПоиска - Строка, Неопределено - элемент параметров выбора: строка, используемая при поиске данных
// 
// Возвращаемое значение:
//  СписокЗначений - содержит ссылки на допустимые значения перечисления
//
Функция ДопустимыеЗначения(Отбор = Неопределено, Знач СтрокаПоиска = Неопределено) Экспорт
	
	ДопустимыеЗначения = Новый СписокЗначений;
	
	// Значения могут быть запрещены для выбора профилем полномочий пользователя
	РазрешенныеЗначения = УправлениеДоступом.РазрешенныеЗначенияДляДинамическогоСписка(
		"Документ.ПриходныйКассовыйОрдер",
		Тип("ПеречислениеСсылка.ВидыОперацийПКО"));
	
	// Получим отобранный и упорядоченный перечень значений с представлениями
	// Сразу исключаем РасчетыПоКредитамИЗаймам, так как он не используется в новых документах
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыОперацийПКО.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ВидыОперацийПКО.Ссылка) КАК Представление,
	|	ВидыОперацийПКО.Порядок КАК Порядок
	|ИЗ
	|	Перечисление.ВидыОперацийПКО КАК ВидыОперацийПКО
	|ГДЕ
	|	ВидыОперацийПКО.Ссылка <> ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.РасчетыПоКредитамИЗаймам)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	
	ТекстыОтбора = Новый Массив;
	
	// Исключаем неразрешенные значения
	Если РазрешенныеЗначения <> Неопределено Тогда
		ТекстыОтбора.Добавить("ВидыОперацийПКО.Ссылка В(&РазрешенныеЗначения)");
		Запрос.УстановитьПараметр("РазрешенныеЗначения", РазрешенныеЗначения);
	КонецЕсли;
	
	ТипОтбора = ТипЗнч(Отбор);
	
	// Исключаем ссылки, переданные в отборе
	Если ТипОтбора = Тип("ПеречислениеСсылка.ВидыОперацийПКО") Тогда
		ТекстыОтбора.Добавить("ВидыОперацийПКО.Ссылка = &Отбор");
		Запрос.УстановитьПараметр("Отбор", Отбор);
	ИначеЕсли ТипОтбора = Тип("ФиксированныйМассив") Тогда
		ТекстыОтбора.Добавить("ВидыОперацийПКО.Ссылка В(&Отбор)");
		Запрос.УстановитьПараметр("Отбор", Отбор);
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ВестиУчетИндивидуальногоПредпринимателя") Тогда
		ТекстыОтбора.Добавить("ВидыОперацийПКО.Ссылка <> Значение(Перечисление.ВидыОперацийПКО.ЛичныеСредстваПредпринимателя)");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстыОтбора) Тогда
		
		СхемаЗапроса = Новый СхемаЗапроса;
		СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
		
		ТекстОтбора = СтрСоединить(ТекстыОтбора, Символы.ПС + " И ");
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить(ТекстОтбора);
		
		Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
		
	КонецЕсли;
	
	// Готовим поиск по наименованию
	ОтборПоПредставлению = (ТипЗнч(СтрокаПоиска) = Тип("Строка") И Не ПустаяСтрока(СтрокаПоиска));
	Если ОтборПоПредставлению Тогда
		СтрокаПоиска = НРег(СтрокаПоиска); // поиск регистронезависимый
	КонецЕсли;
	
	СведенияОбОрганизации = Новый Структура; // может использоваться для проверки допустимости отдельных видов операций
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ОтборПоПредставлению
			И СтрНайти(НРег(Выборка.Представление), СтрокаПоиска) <> 1 Тогда
			Продолжить;
		КонецЕсли;
		
		// Исключаем неподходящие к контексту
		Если Выборка.Ссылка = Перечисления.ВидыОперацийПКО.ЛичныеСредстваПредпринимателя Тогда
			Если СведениеОбОрганизации("ЭтоЮрЛицо", СведенияОбОрганизации, Отбор) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если Выборка.Ссылка = Перечисления.ВидыОперацийПКО.ПолучениеНаличныхВБанке Тогда
			Если Не СведениеОбОрганизации("ЕстьБанковскиеСчета", СведенияОбОрганизации, Отбор) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если Выборка.Ссылка = Перечисления.ВидыОперацийПКО.ВозвратЗаймаРаботником Тогда
			Если Не УчетЗарплаты.ИспользуетсяПодсистемаУчетаЗарплатыИКадров()
				Или Не СведениеОбОрганизации("ЕстьРаботники", СведенияОбОрганизации, Отбор) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		// Остальные - допустимые
		ДопустимыеЗначения.Добавить(Выборка.Ссылка, Выборка.Представление);
		
	КонецЦикла;
	
	Возврат ДопустимыеЗначения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает элемент сведений об организации для ДопустимыеЗначения().
// Позволяет получить только нужные по месту сведения об организации.
// Кеширует полученные значения в СведенияОбОрганизации.
//
// Параметры:
//  ИмяСведений				 - Строка - перечень сведений см. в коде функции
//  СведенияОбОрганизации	 - Структура - кеш; должен быть инициализирован как Новый Структура
//  Отбор					 - Структура - см. параметр Отбор в ДопустимыеЗначения()
// 
// Возвращаемое значение:
//  тип определяется именем запрашиваемого элемента сведений
//
Функция СведениеОбОрганизации(ИмяСведений, СведенияОбОрганизации, Отбор)
	
	Значение = Неопределено;
	Если СведенияОбОрганизации.Свойство(ИмяСведений, Значение) Тогда
		Возврат Значение;
	КонецЕсли;
	
	Если ИмяСведений = "Организация" Тогда
		
		Если ТипЗнч(Отбор) = Тип("Структура")
			И Отбор.Свойство("Организация")
			И ЗначениеЗаполнено(Отбор.Организация) Тогда
			Значение = Отбор.Организация;
		Иначе // Если отбор не передан, получим значение "по умолчанию", либо "единственную" организацию в ИБ.
			Значение = Справочники.Организации.ОрганизацияПоУмолчанию();
		КонецЕсли;
		
	Иначе
		
		Организация = СведениеОбОрганизации("Организация", СведенияОбОрганизации, Отбор);
		
		Если ИмяСведений = "ЭтоЮрЛицо" Тогда
			
			Если ЗначениеЗаполнено(Организация) Тогда
				Значение = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Организация);
			Иначе
				Значение = Истина; // ИП обычно ведет в базе только себя, а в этом случае организация будет получена.
			КонецЕсли;
			
		ИначеЕсли ИмяСведений = "ЕстьБанковскиеСчета" Тогда
			
			Если ЗначениеЗаполнено(Организация) Тогда
				Значение = (Справочники.БанковскиеСчета.КоличествоБанковскихСчетовОрганизации(Организация) > 0);
			Иначе
				Значение = Истина;
			КонецЕсли;
			
		ИначеЕсли ИмяСведений = "ЕстьРаботники" Тогда
			
			Если ЗначениеЗаполнено(Организация) Тогда
				ЭтоЮрЛицо = СведениеОбОрганизации("ЭтоЮрЛицо", СведенияОбОрганизации, Отбор);
				Значение = ЭтоЮрЛицо Или УчетЗарплаты.ИПИспользуетТрудНаемныхРаботников(Организация);
			Иначе
				Значение = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СведенияОбОрганизации.Вставить(ИмяСведений, Значение);
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти

#КонецЕсли
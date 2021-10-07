﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , , Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаЗапрета = Документы.ПрекращениеСтандартныхВычетовНДФЛ.ДатаЗапрета(Дата, Месяц);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	УчетНДФЛ.СформироватьПрименениеСтандартныхВычетов(Движения, Отказ, ДанныеДляПроведения(), , Ложь);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка на дубли движений
	Запрос = Документы.ПрекращениеСтандартныхВычетовНДФЛ.КонфликтующиеРегистраторы(Ссылка, Месяц, Сотрудник);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();   
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекстСообщения = НСтр("ru = 'Не удалось провести заявление. Чтобы изменить вычеты отредактируйте заявление номер %1.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Выборка.Регистратор);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.Регистратор.ПолучитьОбъект());
			Отказ = Истина;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	ДанныеОВычетах = Новый Структура(
		"МесяцРегистрации,ФизическоеЛицо,ГоловнаяОрганизация,
		|ИзменитьВычетыНаДетей,ВычетыНаДетей,
		|ИзменитьЛичныйВычет,КодВычетаЛичный");
	
	ЗаполнитьЗначенияСвойств(ДанныеОВычетах, СведенияДляПрекращенияВычетов());
	ДанныеОВычетах.ИзменитьЛичныйВычет = Истина;
	
	ДанныеОВычетах.Вставить("ВычетыНаДетей", СведенияОПрекращаемыхВычетахНаДетей(ДанныеОВычетах));
	ДанныеОВычетах.ИзменитьВычетыНаДетей = ДанныеОВычетах.ВычетыНаДетей.Количество() > 0;
	
	Возврат ДанныеОВычетах;
	
КонецФункции

Функция СведенияДляПрекращенияВычетов()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Док.Месяц КАК МесяцРегистрации,
	|	Док.Сотрудник КАК ФизическоеЛицо,
	|	Док.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ИЗ
	|	Документ.ПрекращениеСтандартныхВычетовНДФЛ КАК Док
	|ГДЕ
	|	Док.Ссылка = &Документ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Документ", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция СведенияОПрекращаемыхВычетахНаДетей(ДанныеОВычетах)
	
	ТаблицаВычетыНаДетей = Новый ТаблицаЗначений;
	ТаблицаВычетыНаДетей.Колонки.Добавить("ФизическоеЛицо");
	ТаблицаВычетыНаДетей.Колонки.Добавить("МесяцРегистрации");
	ТаблицаВычетыНаДетей.Колонки.Добавить("КодВычета");
	ТаблицаВычетыНаДетей.Колонки.Добавить("ДатаДействия");
	ТаблицаВычетыНаДетей.Колонки.Добавить("КоличествоДетей");
	ТаблицаВычетыНаДетей.Колонки.Добавить("ДействуетДо");
	ТаблицаВычетыНаДетей.Колонки.Добавить("КоличествоДетейПоОкончании");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Месяц",			Месяц);
	Запрос.УстановитьПараметр("ФизическоеЛицо",	Сотрудник);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтандартныеВычетыНаДетейНДФЛ.КодВычета
	|ИЗ
	|	РегистрСведений.СтандартныеВычетыНаДетейНДФЛ КАК СтандартныеВычетыНаДетейНДФЛ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(СтандартныеВычетыНаДетейНДФЛ.МесяцРегистрации) КАК МесяцРегистрации
	|		ИЗ
	|			РегистрСведений.СтандартныеВычетыНаДетейНДФЛ КАК СтандартныеВычетыНаДетейНДФЛ
	|		ГДЕ
	|			СтандартныеВычетыНаДетейНДФЛ.МесяцРегистрации < &Месяц
	|			И СтандартныеВычетыНаДетейНДФЛ.ФизическоеЛицо = &ФизическоеЛицо) КАК ВложенныйЗапрос
	|		ПО СтандартныеВычетыНаДетейНДФЛ.МесяцРегистрации = ВложенныйЗапрос.МесяцРегистрации
	|			И (СтандартныеВычетыНаДетейНДФЛ.ФизическоеЛицо = &ФизическоеЛицо)
	|ГДЕ
	|	СтандартныеВычетыНаДетейНДФЛ.КоличествоДетей > 0
	|	И СтандартныеВычетыНаДетейНДФЛ.ДействуетДо >= &Месяц";
	ВычетыНаДетейВыборка = Запрос.Выполнить().Выбрать();
	
	Пока ВычетыНаДетейВыборка.Следующий() Цикл
		ЗаписьОВычетеНаДетей					= ТаблицаВычетыНаДетей.Добавить();
		ЗаписьОВычетеНаДетей.ФизическоеЛицо		= ДанныеОВычетах.ФизическоеЛицо;
		ЗаписьОВычетеНаДетей.МесяцРегистрации	= ДанныеОВычетах.МесяцРегистрации;
		ЗаписьОВычетеНаДетей.КодВычета			= ВычетыНаДетейВыборка.КодВычета;
		ЗаписьОВычетеНаДетей.ДатаДействия		= ДанныеОВычетах.МесяцРегистрации;
	КонецЦикла;
	
	Возврат ТаблицаВычетыНаДетей;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
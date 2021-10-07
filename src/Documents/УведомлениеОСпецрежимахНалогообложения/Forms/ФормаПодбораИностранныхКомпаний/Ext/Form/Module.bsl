﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Организация = Параметры.Организация;
	Уведомление = Параметры.Уведомление;
	ЗаполнитьСписок();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписок()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Уведомление", Уведомление);
	Запрос.Текст = "ВЫБРАТЬ
	|	УведомлениеОСпецрежимахНалогообложения.Ссылка КАК Ссылка,
	|	УведомлениеОСпецрежимахНалогообложения.ВидУведомления КАК ВидУведомления,
	|	ВЫБОР
	|		КОГДА УведомлениеОСпецрежимахНалогообложения.ДатаПодписи = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА УведомлениеОСпецрежимахНалогообложения.Дата
	|		ИНАЧЕ УведомлениеОСпецрежимахНалогообложения.ДатаПодписи
	|	КОНЕЦ КАК Дата
	|ПОМЕСТИТЬ ВТ_Отчеты
	|ИЗ
	|	Документ.УведомлениеОСпецрежимахНалогообложения КАК УведомлениеОСпецрежимахНалогообложения
	|ГДЕ
	|	(УведомлениеОСпецрежимахНалогообложения.ВидУведомления = ЗНАЧЕНИЕ(Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО)
	|			ИЛИ УведомлениеОСпецрежимахНалогообложения.ВидУведомления = ЗНАЧЕНИЕ(Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК))
	|	И УведомлениеОСпецрежимахНалогообложения.Организация = &Организация
	|	И УведомлениеОСпецрежимахНалогообложения.Ссылка <> &Уведомление
	|	И НЕ УведомлениеОСпецрежимахНалогообложения.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Отчеты.Ссылка КАК Ссылка,
	|	ВТ_Отчеты.ВидУведомления КАК ВидУведомления,
	|	ВТ_Отчеты.Дата КАК Дата
	|ИЗ
	|	ВТ_Отчеты КАК ВТ_Отчеты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	ИтоговыйРезультат = Новый Соответствие;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		Если Выборка.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО Тогда 
			ДополнитьПоУИО(ИтоговыйРезультат, Выборка.Ссылка);
		Иначе
			ДополнитьПоКИК(ИтоговыйРезультат, Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого КЗ Из ИтоговыйРезультат Цикл 
		НовСтр = ИностранныеОрганизации.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, КЗ.Значение);
		НовСтр.Флажок = 1;
		НовСтр.Номер = КЗ.Ключ;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьПустуюСтруктуруПоОрганизации(Уведомление)
	Р = Новый Структура;
	Р.Вставить("Название");
	Р.Вставить("Уведомление", Уведомление);
	Р.Вставить("НаимРус");
	Р.Вставить("НаимЛат");
	Р.Вставить("РегНом");
	Р.Вставить("Адр");
	Р.Вставить("КодСтраны");
	Р.Вставить("КодНалогоплательщика");
	Р.Вставить("ДоляУчастия");
	Р.Вставить("ДатаУчастия");
	Возврат Р;
КонецФункции

&НаСервере
Процедура ДополнитьПоУИО(ИтоговыйРезультат, Ссылка)
	ДанныеОтчета = Ссылка.ДанныеУведомления.Получить();
	Основание = ДанныеОтчета.Титульный[0].Основание;
	Для Каждого Стр Из ДанныеОтчета.СведИО Цикл
		Ключ = "ИО-" + Формат(Стр.ИО_Номер, "ЧЦ=5; ЧН=; ЧВН=; ЧГ=");
		Если Основание = "3" Или (ЗначениеЗаполнено(Стр.ДатаКон1) И Стр.ДатаКон1 < НачалоДня(ТекущаяДатаСеанса())) Тогда 
			ИтоговыйРезультат.Удалить(Ключ);
		Иначе
			СтрОрг = ПолучитьПустуюСтруктуруПоОрганизации(Ссылка);
			СтрОрг.Название = Стр.ИО_ПолноеНаименование_RUS;
			СтрОрг.НаимРус = Стр.ИО_ПолноеНаименование_RUS;
			СтрОрг.НаимЛат = Стр.ИО_ПолноеНаименование_EN;
			СтрОрг.РегНом = Стр.РегНом1;
			СтрОрг.Адр = Стр.ИнАдр1;
			СтрОрг.КодСтраны = Стр.КодСтранаРегистрации;
			СтрОрг.КодНалогоплательщика = Стр.КодНом1;
			СтрОрг.ДоляУчастия = Стр.ДоляУчастия1;
			СтрОрг.ДатаУчастия = Стр.ДатаНач1;
			ИтоговыйРезультат.Вставить(Ключ, СтрОрг);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДополнитьПоКИК(ИтоговыйРезультат, Ссылка)
	ДанныеОтчета = Ссылка.ДанныеУведомления.Получить();
	Для Каждого Стр Из ДанныеОтчета.ДанныеМногостраничныхРазделов.ЛистА Цикл
		Ключ = "ИО-" + Формат(Стр.Значение.НомерКИКЧисло, "ЧЦ=5; ЧН=; ЧВН=; ЧГ=");
		СтрОрг = ПолучитьПустуюСтруктуруПоОрганизации(Ссылка);
		СтрОрг.Название = Стр.Значение.НаимОрг;
		СтрОрг.НаимРус = Стр.Значение.НаимОрг;
		СтрОрг.НаимЛат = Стр.Значение.НаимОргЛат;
		СтрОрг.РегНом = Стр.Значение.РегНомер;
		СтрОрг.Адр = Стр.Значение.АдрСтрРег;
		СтрОрг.КодСтраны = Стр.Значение.СтрРег;
		СтрОрг.КодНалогоплательщика = Стр.Значение.КодНПРег;
		ИтоговыйРезультат.Вставить(Ключ, СтрОрг);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для Каждого Стр Из ИностранныеОрганизации Цикл 
		Стр.Флажок = 1;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	Для Каждого Стр Из ИностранныеОрганизации Цикл 
		Стр.Флажок = 0;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция СформироватьРезультатВыбора()
	ТЗРез = ИностранныеОрганизации.Выгрузить();
	ТЗРез.Очистить();
	Для Каждого Стр Из ИностранныеОрганизации Цикл 
		Если Стр.Флажок <> 0 Тогда 
			НовСтр = ТЗРез.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, Стр);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(ТЗРез, Новый УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура Выбрать(Команда)
	Закрыть(Новый Структура("РезультатЗакрытия", СформироватьРезультатВыбора()));
КонецПроцедуры

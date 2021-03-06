
#Область СлужебныйПрограммныйИнтерфейс

#Область РасчетНалогаНаИмущество
 
Функция ПустаяСправкаРасчет(ИмяРегистраСведений) Экспорт

	Возврат УправлениеВнеоборотнымиАктивами.ПустаяСправкаРасчет(ИмяРегистраСведений);

КонецФункции
 
Процедура ДополнитьПараметрыРасчетаНалогаНаИмущество(ПараметрыРасчета, Организация, ПериодРасчета, ДополнительныеПараметрыРасчета) Экспорт

	
КонецПроцедуры

Процедура УстановитьПараметрыЗапросаПриРасчетеНалогаЗаПериод(Период, Запрос) Экспорт

	
	
КонецПроцедуры
 
Процедура ДобавитьТекстЗапросаКоэффициентыЕНВД_ПоОС(СписокЗапросов) Экспорт

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СпособыОтраженияРасходов.ОсновноеСредство КАК ОсновноеСредство,
	|	КоэффициентыЕНВД.НеЕНВД КАК НеЕНВД,
	|	КоэффициентыЕНВД.Распределение КАК Распределение
	|ПОМЕСТИТЬ КоэффициентыЕНВД_ПоОС
	|ИЗ
	|	РегистрСведений.СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						СписокОС)) КАК СпособыОтраженияРасходов
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоэффициентыЕНВД КАК КоэффициентыЕНВД
	|		ПО СпособыОтраженияРасходов.СпособыОтраженияРасходовПоАмортизации = КоэффициентыЕНВД.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство";
	
	СписокЗапросов.Добавить(ТекстЗапроса);
	
КонецПроцедуры

Процедура СоздатьВТКоэффициентыЕНВД(ПараметрыРасчета) Экспорт

	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СпособыОтраженияРасходовПоАмортизацииСпособы.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА СпособыОтраженияРасходовПоАмортизацииСпособы.Субконто1 ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ВЫРАЗИТЬ(СпособыОтраженияРасходовПоАмортизацииСпособы.Субконто1 КАК Справочник.СтатьиЗатрат)
	|		КОГДА СпособыОтраженияРасходовПоАмортизацииСпособы.Субконто2 ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ВЫРАЗИТЬ(СпособыОтраженияРасходовПоАмортизацииСпособы.Субконто2 КАК Справочник.СтатьиЗатрат)
	|		КОГДА СпособыОтраженияРасходовПоАмортизацииСпособы.Субконто3 ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ВЫРАЗИТЬ(СпособыОтраженияРасходовПоАмортизацииСпособы.Субконто3 КАК Справочник.СтатьиЗатрат)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ПустаяСсылка)
	|	КОНЕЦ КАК СтатьяЗатрат,
	|	СпособыОтраженияРасходовПоАмортизацииСпособы.Коэффициент КАК Коэффициент
	|ПОМЕСТИТЬ ВТ_КоэффициентыСтатейЗатрат
	|ИЗ
	|	Справочник.СпособыОтраженияРасходовПоАмортизации.Способы КАК СпособыОтраженияРасходовПоАмортизацииСпособы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КоэффициентыСтатейЗатрат.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА КоэффициентыСтатейЗатрат.СтатьяЗатрат = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ПустаяСсылка)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|		ИНАЧЕ КоэффициентыСтатейЗатрат.СтатьяЗатрат.ВидДеятельностиДляНалоговогоУчетаЗатрат
	|	КОНЕЦ КАК ОтношениеКЕНВД,
	|	СУММА(КоэффициентыСтатейЗатрат.Коэффициент) КАК Коэффициент
	|ПОМЕСТИТЬ ВТ_ВыборкаКоэффициентов
	|ИЗ
	|	ВТ_КоэффициентыСтатейЗатрат КАК КоэффициентыСтатейЗатрат
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА КоэффициентыСтатейЗатрат.СтатьяЗатрат = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ПустаяСсылка)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|		ИНАЧЕ КоэффициентыСтатейЗатрат.СтатьяЗатрат.ВидДеятельностиДляНалоговогоУчетаЗатрат
	|	КОНЕЦ,
	|	КоэффициентыСтатейЗатрат.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КоэффициентыСтатейЗатрат.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КоэффициентыСтатейЗатрат.Ссылка КАК Ссылка,
	|	СУММА(КоэффициентыСтатейЗатрат.Коэффициент) КАК СуммаКоэффициентов
	|ПОМЕСТИТЬ ВТ_ВыборкаСуммыКоэффициентов
	|ИЗ
	|	ВТ_КоэффициентыСтатейЗатрат КАК КоэффициентыСтатейЗатрат
	|
	|СГРУППИРОВАТЬ ПО
	|	КоэффициентыСтатейЗатрат.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КоэффициентыСтатейЗатрат.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВыборкаКоэффициентов.Ссылка КАК Ссылка,
	|	СУММА(ВЫБОР
	|			КОГДА ВыборкаКоэффициентов.ОтношениеКЕНВД = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|				ТОГДА ВыборкаКоэффициентов.Коэффициент / ВыборкаСуммыКоэффициентов.СуммаКоэффициентов
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НеЕНВД,
	|	СУММА(ВЫБОР
	|			КОГДА ВыборкаКоэффициентов.ОтношениеКЕНВД = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты)
	|				ТОГДА ВыборкаКоэффициентов.Коэффициент / ВыборкаСуммыКоэффициентов.СуммаКоэффициентов
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Распределение
	|ПОМЕСТИТЬ КоэффициентыЕНВД
	|ИЗ
	|	ВТ_ВыборкаКоэффициентов КАК ВыборкаКоэффициентов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВыборкаСуммыКоэффициентов КАК ВыборкаСуммыКоэффициентов
	|		ПО ВыборкаКоэффициентов.Ссылка = ВыборкаСуммыКоэффициентов.Ссылка
	|ГДЕ
	|	ВыборкаКоэффициентов.ОтношениеКЕНВД <> ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВыборкаКоэффициентов.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_КоэффициентыСтатейЗатрат
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_ВыборкаКоэффициентов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_ВыборкаСуммыКоэффициентов";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = ПараметрыРасчета.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры
 
Процедура СоздатьВТДвижимоеИмуществоПринятоеКУчетуПосле2013(ПараметрыРасчета) Экспорт

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СостоянияОСОрганизаций.ОсновноеСредство КАК ОС
	|ПОМЕСТИТЬ ВТДвижимоеИмуществоПринятоеКУчетуПосле2013
	|ИЗ
	|	РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОСОрганизаций
	|ГДЕ
	|	(СостоянияОСОрганизаций.Организация = &ГоловнаяОрганизация
	|			ИЛИ СостоянияОСОрганизаций.Организация.ГоловнаяОрганизация = &ГоловнаяОрганизация)
	|				И СостоянияОСОрганизаций.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету)
	|				И СостоянияОСОрганизаций.ДатаСостояния <= &КонецПериодаОтчета
	|				И СостоянияОСОрганизаций.Активность = ИСТИНА
	|				И НЕ СостоянияОСОрганизаций.ОсновноеСредство.НедвижимоеИмущество
	|				И &ДопУсловие
	|
	|СГРУППИРОВАТЬ ПО
	|	СостоянияОСОрганизаций.ОсновноеСредство
	|
	|ИМЕЮЩИЕ
	|	МИНИМУМ(СостоянияОСОрганизаций.ДатаСостояния) >= ДАТАВРЕМЯ(2013, 1, 1)";
	
	Если Метаданные.Документы.Найти("АвизоОСВходящее") <> Неопределено Тогда 
		ДопУсловие = "И НЕ СостоянияОСОрганизаций.Регистратор ССЫЛКА Документ.АвизоОСВходящее";
	Иначе
		ДопУсловие = "";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ДопУсловие", ДопУсловие);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = ПараметрыРасчета.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("КонецПериодаОтчета", КонецГода(ПараметрыРасчета.ПериодРасчета));
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(ПараметрыРасчета.Организация));
	
	Запрос.Выполнить();
	
КонецПроцедуры
 
Процедура ДобавитьТекстЗапросаОССостоящиеНаУчете(ПараметрыРасчета, СписокЗапросов) Экспорт

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ОС.Ссылка КАК ОсновноеСредство,
	|	ОС.ГруппаОС КАК ГруппаОС,
	|	ОС.НедвижимоеИмущество КАК НедвижимоеИмущество
	|ПОМЕСТИТЬ ВТ_ОССостоящиеНаУчете
	|ИЗ
	|	Справочник.ОсновныеСредства КАК ОС
	|ГДЕ
	|	НЕ ОС.Ссылка В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					СостоянияОСОрганизаций.ОсновноеСредство
	|				ИЗ
	|					РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОСОрганизаций
	|				ГДЕ
	|					СостоянияОСОрганизаций.Организация = &Организация
	|					И СостоянияОСОрганизаций.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.СнятоСУчета)
	|					И СостоянияОСОрганизаций.ДатаСостояния < &КонецПериода
	|					И СостоянияОСОрганизаций.Активность)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство";
	
	СписокЗапросов.Добавить(ТекстЗапроса);
	
КонецПроцедуры
 
Процедура ДобавитьТекстЗапросаСписокОС(СписокЗапросов) Экспорт

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПервоначальныеСведенияОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ПервоначальныеСведенияОС.ПорядокПогашенияСтоимости КАК ПорядокПогашенияСтоимости
	|ПОМЕСТИТЬ СписокОС
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						СписокРазрешенныхОС.ОсновноеСредство
	|					ИЗ
	|						СписокРазрешенныхОС КАК СписокРазрешенныхОС)) КАК ПервоначальныеСведенияОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПервоначальныеСведенияОС.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СписокРазрешенныхОС";
	
	СписокЗапросов.Добавить(ТекстЗапроса);
	
КонецПроцедуры
 
Процедура ДобавитьТекстЗапросаСчетаБухгалтерскогоУчета(СписокЗапросов) Экспорт

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СчетаБухгалтерскогоУчета.ОсновноеСредство КАК ОсновноеСредство,
	|	СчетаБухгалтерскогоУчета.СчетУчета КАК СчетУчета,
	|	СчетаБухгалтерскогоУчета.СчетНачисленияАмортизации КАК СчетНачисленияАмортизации
	|ПОМЕСТИТЬ ВТ_СчетаБухгалтерскогоУчета
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|			&КонецПериода,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						СписокОС КАК СписокОС)) КАК СчетаБухгалтерскогоУчета
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство";
	
	СписокЗапросов.Добавить(ТекстЗапроса);
	
КонецПроцедуры
 
Процедура ДобавитьТекстЗапросаСтоимостьИАмортизация(Период, ПараметрыРасчета, СписокЗапросов) Экспорт

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетаБухгалтерскогоУчета.СчетУчета КАК СчетУчета
	|ПОМЕСТИТЬ ВТ_СчетаУчета
	|ИЗ
	|	ВТ_СчетаБухгалтерскогоУчета КАК СчетаБухгалтерскогоУчета
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетаБухгалтерскогоУчета.СчетНачисленияАмортизации КАК СчетНачисленияАмортизации
	|ПОМЕСТИТЬ ВТ_СчетаНачисленияАмортизации
	|ИЗ
	|	ВТ_СчетаБухгалтерскогоУчета КАК СчетаБухгалтерскогоУчета
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетНачисленияАмортизации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АмортизацияОС.СуммаОстатокДт КАК СуммаОстатокДт,
	|	АмортизацияОС.СуммаОстатокКт КАК СуммаОстатокКт,
	|	АмортизацияОС.Субконто1 КАК ОсновноеСредство,
	|	АмортизацияОС.Счет КАК Счет
	|ПОМЕСТИТЬ ВТ_АмортизацияОС
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&Период,
	|			Счет В
	|				(ВЫБРАТЬ
	|					ВТ_СчетаНачисленияАмортизации.СчетНачисленияАмортизации
	|				ИЗ
	|					ВТ_СчетаНачисленияАмортизации),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
	|			Организация = &Организация) КАК АмортизацияОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПервоначальнаяСтоимостьОС.СуммаОстатокДт КАК СуммаОстатокДт,
	|	ПервоначальнаяСтоимостьОС.Субконто1 КАК ОсновноеСредство,
	|	ПервоначальнаяСтоимостьОС.Счет КАК Счет
	|ПОМЕСТИТЬ ВТ_ПервоначальнаяСтоимостьОС
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&Период,
	|			Счет В
	|				(ВЫБРАТЬ
	|					ВТ_СчетаУчета.СчетУчета
	|				ИЗ
	|					ВТ_СчетаУчета),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
	|			Организация = &Организация) КАК ПервоначальнаяСтоимостьОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_СчетаУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_СчетаНачисленияАмортизации";
	
	СписокЗапросов.Добавить(ТекстЗапроса);
	
КонецПроцедуры
 
#КонецОбласти

#Область РасчетТранспортногоНалога

Функция ПолучитьРасходыНаПлатон(Организация, ПериодРасчета, ТаблицаРасчетТранспортногоНалога) Экспорт

	РасходыПлатон = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",    Организация);
	Запрос.УстановитьПараметр("СледующийМесяц", КонецКвартала(ПериодРасчета) + 1);
	
	АналитикаРасчетов = Новый СписокЗначений;
	АналитикаРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	АналитикаРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	АналитикаРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами);
	
	Запрос.УстановитьПараметр("АналитикаРасчетов", АналитикаРасчетов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасходыНаПлатонОстатки.ОсновноеСредство КАК ОсновноеСредство,
	|	РасходыНаПлатонОстатки.СчетУчета КАК Счет,
	|	РасходыНаПлатонОстатки.Контрагент КАК Контрагент,
	|	РасходыНаПлатонОстатки.ДоговорКонтрагента КАК Договор,
	|	РасходыНаПлатонОстатки.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом,
	|	РасходыНаПлатонОстатки.Подразделение КАК Подразделение,
	|	РасходыНаПлатонОстатки.СуммаОстаток КАК Сумма
	|ПОМЕСТИТЬ РасходыНаПлатон
	|ИЗ
	|	РегистрНакопления.РасходыНаПлатон.Остатки(&СледующийМесяц, Организация = &Организация) КАК РасходыНаПлатонОстатки
	|ГДЕ
	|	РасходыНаПлатонОстатки.СуммаОстаток <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Контрагент,
	|	Договор,
	|	ДокументРасчетовСКонтрагентом
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОстатки.Счет КАК Счет,
	|	ЕСТЬNULL(ХозрасчетныйОстатки.Подразделение, ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)) КАК Подразделение,
	|	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
	|	ХозрасчетныйОстатки.Субконто2 КАК Договор,
	|	ХозрасчетныйОстатки.Субконто3 КАК ДокументРасчетовСКонтрагентом,
	|	ХозрасчетныйОстатки.СуммаОстатокКт КАК Сумма
	|ПОМЕСТИТЬ Задолженность
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&СледующийМесяц,
	|			Счет В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					РасходыНаПлатон.Счет
	|				ИЗ
	|					РасходыНаПлатон),
	|			&АналитикаРасчетов,
	|			Организация = &Организация
	|				И (Субконто1, Субконто2, Субконто3) В
	|					(ВЫБРАТЬ
	|						РасходыНаПлатон.Контрагент,
	|						РасходыНаПлатон.Договор,
	|						РасходыНаПлатон.ДокументРасчетовСКонтрагентом
	|					ИЗ
	|						РасходыНаПлатон)) КАК ХозрасчетныйОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Контрагент,
	|	Договор,
	|	ДокументРасчетовСКонтрагентом
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходыНаПлатон.ОсновноеСредство,
	|	РасходыНаПлатон.Счет КАК СчетУчета,
	|	РасходыНаПлатон.Контрагент,
	|	РасходыНаПлатон.Договор КАК ДоговорКонтрагента,
	|	РасходыНаПлатон.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом,
	|	РасходыНаПлатон.Подразделение КАК Подразделение,
	|	РасходыНаПлатон.Сумма - ЕСТЬNULL(Задолженность.Сумма, 0) КАК СуммаНУДт,
	|	РасходыНаПлатон.Сумма - ЕСТЬNULL(Задолженность.Сумма, 0) КАК СуммаНУКт
	|ИЗ
	|	РасходыНаПлатон КАК РасходыНаПлатон
	|		ЛЕВОЕ СОЕДИНЕНИЕ Задолженность КАК Задолженность
	|		ПО РасходыНаПлатон.Счет = Задолженность.Счет
	|			И РасходыНаПлатон.Подразделение = Задолженность.Подразделение
	|			И РасходыНаПлатон.Контрагент = Задолженность.Контрагент
	|			И РасходыНаПлатон.Договор = Задолженность.Договор
	|			И РасходыНаПлатон.ДокументРасчетовСКонтрагентом = Задолженность.ДокументРасчетовСКонтрагентом
	|ГДЕ
	|	РасходыНаПлатон.Сумма - ЕСТЬNULL(Задолженность.Сумма, 0) > 0";
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		РасходыПлатон = Результат.Выгрузить();
	КонецЕсли;
	
	Возврат РасходыПлатон;
	
КонецФункции

Процедура ДополнитьРасчетТранспортногоНалога(РасчетТранспортногоНалога, Знач ДатаКонцаПериодаОтчета) Экспорт
	
	РасчетТранспортногоНалога.Колонки.Добавить("КодПоОКТМОРегиона", 
		ОбщегоНазначения.ОписаниеТипаСтрока(8));
		
	РасчетТранспортногоНалога.Колонки.Добавить("КатегорияТС", 
		Новый ОписаниеТипов("ПеречислениеСсылка.КатегорииТранспортныхСредств"));
		
	РасчетТранспортногоНалога.Колонки.Добавить("НалоговаяСтавка", 
		ОбщегоНазначения.ОписаниеТипаЧисло(11, 2));
		
	РасчетТранспортногоНалога.Колонки.Добавить("НалоговаяСтавкаЗависитОтГодаВыпускаТС", 
		Новый ОписаниеТипов("Булево"));
		
	РасчетТранспортногоНалога.Колонки.Добавить("ОтсутствуетСтавка", Новый ОписаниеТипов("Булево"));
		
	Макет = РегистрыСведений.РегистрацияТранспортныхСредств.ПолучитьМакет("КодыВидовИКатегорииТС");
	КодыВидовИКатегорииТС = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	
	Для Каждого СтрокаРасчета Из РасчетТранспортногоНалога Цикл
		
		КодПоОКТМО = Лев(СтрокаРасчета.КодПоОКТМО, 3);

		Если НЕ (КодПоОКТМО = "118" ИЛИ КодПоОКТМО = "718" ИЛИ КодПоОКТМО = "719") Тогда
			СтрокаРасчета.КодПоОКТМОРегиона = Лев(КодПоОКТМО, 2) + "000000";
		Иначе
			СтрокаРасчета.КодПоОКТМОРегиона = КодПоОКТМО + "00000";
		КонецЕсли;
		
		НайденнаяСтрока = КодыВидовИКатегорииТС.Найти(СтрокаРасчета.КодВидаТранспортногоСредства, "КодВида");
		Если НайденнаяСтрока <> Неопределено Тогда
			СтрокаРасчета.КатегорияТС = Перечисления.КатегорииТранспортныхСредств[НайденнаяСтрока.Категория];
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаРасчета.ДатаВыпуска) Тогда
			СтрокаРасчета.КоличествоЛетПрошедшихСГодаВыпускаТС = 
				Год(ДатаКонцаПериодаОтчета) - Год(СтрокаРасчета.ДатаВыпуска);
		КонецЕсли;
		
	КонецЦикла;
	
	КолонкиДляОпределенияСтавок = "КодПоОКТМОРегиона,КатегорияТС,НалоговаяБаза,КоличествоЛетПрошедшихСГодаВыпускаТС";
	ТаблицаДляОпределенияСтавок = РасчетТранспортногоНалога.Скопировать(,КолонкиДляОпределенияСтавок);
	ТаблицаДляОпределенияСтавок.Свернуть(КолонкиДляОпределенияСтавок);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДляОпределенияСтавок", ТаблицаДляОпределенияСтавок);
	Запрос.УстановитьПараметр("Период", ДатаКонцаПериодаОтчета);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДляОпределенияСтавок.КодПоОКТМОРегиона КАК КодПоОКТМОРегиона,
	|	ТаблицаДляОпределенияСтавок.КатегорияТС КАК КатегорияТС,
	|	ТаблицаДляОпределенияСтавок.НалоговаяБаза КАК НалоговаяБаза,
	|	ТаблицаДляОпределенияСтавок.КоличествоЛетПрошедшихСГодаВыпускаТС КАК КоличествоЛетПрошедшихСГодаВыпускаТС
	|ПОМЕСТИТЬ ВТДляОпределенияСтавок
	|ИЗ
	|	&ТаблицаДляОпределенияСтавок КАК ТаблицаДляОпределенияСтавок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтавкиТранспортногоНалога.Период КАК Период,
	|	СтавкиТранспортногоНалога.ОКТМО КАК ОКТМО,
	|	СтавкиТранспортногоНалога.НаименованиеОбъектаНалогообложения КАК НаименованиеОбъектаНалогообложения,
	|	СтавкиТранспортногоНалога.МинимальноеЗначениеМощности КАК МинимальноеЗначениеМощности,
	|	СтавкиТранспортногоНалога.МаксимальноеЗначениеМощности КАК МаксимальноеЗначениеМощности,
	|	СтавкиТранспортногоНалога.МинимальноеКоличествоЛетСГодаВыпускаТС КАК МинимальноеКоличествоЛетСГодаВыпускаТС,
	|	СтавкиТранспортногоНалога.МаксимальноеКоличествоЛетСГодаВыпускаТС КАК МаксимальноеКоличествоЛетСГодаВыпускаТС,
	|	СтавкиТранспортногоНалога.НалоговаяСтавка КАК НалоговаяСтавка,
	|	ВТДляОпределенияСтавок.НалоговаяБаза КАК НалоговаяБаза,
	|	ВТДляОпределенияСтавок.КоличествоЛетПрошедшихСГодаВыпускаТС КАК КоличествоЛетПрошедшихСГодаВыпускаТС
	|ПОМЕСТИТЬ ВТВсеПодходящиеЗаписи
	|ИЗ
	|	ВТДляОпределенияСтавок КАК ВТДляОпределенияСтавок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиТранспортногоНалога КАК СтавкиТранспортногоНалога
	|		ПО ВТДляОпределенияСтавок.КодПоОКТМОРегиона = СтавкиТранспортногоНалога.ОКТМО
	|			И ВТДляОпределенияСтавок.КатегорияТС = СтавкиТранспортногоНалога.НаименованиеОбъектаНалогообложения
	|			И (СтавкиТранспортногоНалога.МинимальноеЗначениеМощности <= ВТДляОпределенияСтавок.НалоговаяБаза)
	|			И (СтавкиТранспортногоНалога.МаксимальноеЗначениеМощности = 0
	|				ИЛИ ВТДляОпределенияСтавок.НалоговаяБаза <= СтавкиТранспортногоНалога.МаксимальноеЗначениеМощности)
	|			И (СтавкиТранспортногоНалога.МинимальноеКоличествоЛетСГодаВыпускаТС <= ВТДляОпределенияСтавок.КоличествоЛетПрошедшихСГодаВыпускаТС)
	|			И (СтавкиТранспортногоНалога.МаксимальноеКоличествоЛетСГодаВыпускаТС = 0
	|				ИЛИ ВТДляОпределенияСтавок.КоличествоЛетПрошедшихСГодаВыпускаТС <= СтавкиТранспортногоНалога.МаксимальноеКоличествоЛетСГодаВыпускаТС)
	|ГДЕ
	|	СтавкиТранспортногоНалога.Период < &Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВТВсеПодходящиеЗаписи.Период) КАК Период,
	|	ВТВсеПодходящиеЗаписи.ОКТМО КАК ОКТМО,
	|	ВТВсеПодходящиеЗаписи.НаименованиеОбъектаНалогообложения КАК НаименованиеОбъектаНалогообложения,
	|	ВТВсеПодходящиеЗаписи.НалоговаяБаза КАК НалоговаяБаза,
	|	ВТВсеПодходящиеЗаписи.КоличествоЛетПрошедшихСГодаВыпускаТС КАК КоличествоЛетПрошедшихСГодаВыпускаТС
	|ПОМЕСТИТЬ ВТПоследниеСтавки
	|ИЗ
	|	ВТВсеПодходящиеЗаписи КАК ВТВсеПодходящиеЗаписи
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТВсеПодходящиеЗаписи.КоличествоЛетПрошедшихСГодаВыпускаТС,
	|	ВТВсеПодходящиеЗаписи.НалоговаяБаза,
	|	ВТВсеПодходящиеЗаписи.НаименованиеОбъектаНалогообложения,
	|	ВТВсеПодходящиеЗаписи.ОКТМО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВсеПодходящиеЗаписи.ОКТМО КАК КодПоОКТМОРегиона,
	|	ВТВсеПодходящиеЗаписи.НаименованиеОбъектаНалогообложения КАК КатегорияТС,
	|	ВТВсеПодходящиеЗаписи.НалоговаяБаза КАК НалоговаяБаза,
	|	ВТВсеПодходящиеЗаписи.КоличествоЛетПрошедшихСГодаВыпускаТС КАК КоличествоЛетПрошедшихСГодаВыпускаТС,
	|	ВТВсеПодходящиеЗаписи.МинимальноеКоличествоЛетСГодаВыпускаТС <> 0
	|		ИЛИ ВТВсеПодходящиеЗаписи.МаксимальноеКоличествоЛетСГодаВыпускаТС <> 0 КАК НалоговаяСтавкаЗависитОтГодаВыпускаТС,
	|	ВТВсеПодходящиеЗаписи.НалоговаяСтавка КАК НалоговаяСтавка
	|ИЗ
	|	ВТВсеПодходящиеЗаписи КАК ВТВсеПодходящиеЗаписи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПоследниеСтавки КАК ВТПоследниеСтавки
	|		ПО ВТВсеПодходящиеЗаписи.Период = ВТПоследниеСтавки.Период 
	|			И ВТВсеПодходящиеЗаписи.ОКТМО = ВТПоследниеСтавки.ОКТМО
	|			И ВТВсеПодходящиеЗаписи.НаименованиеОбъектаНалогообложения = ВТПоследниеСтавки.НаименованиеОбъектаНалогообложения
	|			И ВТВсеПодходящиеЗаписи.НалоговаяБаза = ВТПоследниеСтавки.НалоговаяБаза
	|			И ВТВсеПодходящиеЗаписи.КоличествоЛетПрошедшихСГодаВыпускаТС = ВТПоследниеСтавки.КоличествоЛетПрошедшихСГодаВыпускаТС";
	
	ТаблицаСтавок = Запрос.Выполнить().Выгрузить();
	Отбор = Новый Структура(КолонкиДляОпределенияСтавок);
	Для Каждого СтрокаРасчета Из РасчетТранспортногоНалога Цикл
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаРасчета);
		НайденныеСтроки = ТаблицаСтавок.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(СтрокаРасчета, НайденныеСтроки[0], , КолонкиДляОпределенияСтавок);
		Иначе
			СтрокаРасчета.ОтсутствуетСтавка = Истина;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СоздатьНалоговыеОрганыСУстановленнойУплатойАвансов(МенеджерВременныхТаблиц, СписокОрганизаций, Период, Налог) Экспорт

	РегистрыСведений.ПорядокУплатыНалоговНаМестах.СоздатьНалоговыеОрганыСУстановленнойУплатойАвансов(
		МенеджерВременныхТаблиц, 
		СписокОрганизаций, 
		Период, 
		Налог);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

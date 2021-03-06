#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
			
	// Справка о валютных операциях.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор	= "СправкаОВалютныхОперациях";
	КомандаПечати.Представление	= НСтр("ru = 'Справка о валютных операциях'");
	Если НЕ бит_ОбщегоНазначения.ЭтоУТ() Тогда
		КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КонецЕсли;
	КомандаПечати.Порядок		= 10;	
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СправкаОВалютныхОперациях") Тогда					
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СправкаОВалютныхОперациях",
			НСтр("ru = 'Справка о валютных операциях'"), 
			СформироватьПечатнуюФормуСВО(МассивОбъектов),,
			"Документ.бит_СправкаОВалютныхОперациях.СправкаОВалютныхОперациях");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);		

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция возвращает актуальную справку о валютных операциях.
// 
// Параметры:
//  ДатаЗаполнения 	- Дата - дата заполнения.
//  Банк 			- СправочникСсылка.Банки - реквизит справки.
//  Организация 	- СправочникСсылка.Организации - реквизит справки.
//  БанковскийСчет 	- СправочникСсылка.БанковскиеСчета - реквизит справки.
// 
// Возвращаемое значение:
//  ДокументСсылка.бит_вк_СправкаОВалютныхОперациях - Актуальная справка.
// 
Функция АктуальнаяСправка(ДатаЗаполнения, Банк, Организация, БанковскийСчет) Экспорт
	
	Результат = Документы.бит_СправкаОВалютныхОперациях.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ДатаЗаполнения"	, ДатаЗаполнения);
	Запрос.УстановитьПараметр("Банк"			, Банк);
	Запрос.УстановитьПараметр("Организация"		, Организация);
	Запрос.УстановитьПараметр("БанковскийСчет"	, БанковскийСчет);
	
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Документ.Ссылка
		|ИЗ
		|	Документ.бит_СправкаОВалютныхОперациях КАК Документ
		|ГДЕ
		|	Документ.Проведен
		|	И Документ.ДатаЗаполнения = &ДатаЗаполнения
		|	И Документ.Банк = &Банк
		|	И Документ.Организация = &Организация
		|	И Документ.БанковскийСчет = &БанковскийСчет
		|
		|УПОРЯДОЧИТЬ ПО
		|	Документ.МоментВремени УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		Результат = РезультатЗапроса.Ссылка;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);

	НомераТаблиц = Новый Структура;

	Запрос.Текст = ТекстЗапросаРеквизиты(НомераТаблиц)
		+ ТекстЗапросаВалютныеОперации(НомераТаблиц);

	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции

Процедура ПроверитьВозможностьПроведения(Реквизиты,Объект,РеквизитыМетаданных,Отказ) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка"				, Реквизиты.Регистратор);
	Запрос.УстановитьПараметр("Банк"				, Реквизиты.Банк);
	Запрос.УстановитьПараметр("Организация"			, Реквизиты.Организация);
	Запрос.УстановитьПараметр("БанковскийСчет"		, Реквизиты.БанковскийСчет);	
	Запрос.УстановитьПараметр("ДокументОснование"	, Реквизиты.ДокументОснование);
	Запрос.УстановитьПараметр("ДатаЗаполнения"		, Реквизиты.ДатаЗаполнения);
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Документ.Ссылка
		|ИЗ
		|	Документ.бит_СправкаОВалютныхОперациях КАК Документ
		|ГДЕ
		|	Документ.Проведен
		|	И Документ.ДатаЗаполнения = &ДатаЗаполнения
		|	И Документ.Банк = &Банк
		|	И Документ.Организация = &Организация
		|	И Документ.БанковскийСчет = &БанковскийСчет
		|	И Документ.Ссылка <> &Ссылка
		|	И Документ.ДокументОснование = &ДокументОснование";
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		
		ШаблонСообщения = "Дублирование Справки о валютных операциях";
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("ПОЛЕ"
							,"КОРРЕКТНОСТЬ"
							,РеквизитыМетаданных.Банк.Представление()
							,
							,
							,ШаблонСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения
							,Объект
							,"Банк"
							,
							,Отказ);
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("ПОЛЕ"
							,"КОРРЕКТНОСТЬ"
							,РеквизитыМетаданных.ДатаЗаполнения.Представление()
							,
							,
							,ШаблонСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения
							,Объект
							,"ДатаЗаполнения"
							,
							,Отказ);
						
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьВозможностьУдаленияПроведения(Ссылка, Отказ) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Документ.Ссылка
	|ИЗ
	|	Документ.бит_СправкаОВалютныхОперациях КАК Документ
	|ГДЕ
	|	Документ.ДокументОснование = &Ссылка
	|	И Документ.Проведен";
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		бит_ОбщегоНазначения.СообщитьОбОшибке(
			НСтр("ru = 'Существуют корректировочные справки к текущему документу. Отмена проведения невозможна!.'"),
			Отказ,,
			СтатусСообщения.Важное);
	КонецЕсли;

КонецПроцедуры

Процедура ДвиженияПоРегиструДанныеПоПаспортамСделок(ВалютныеОперации, Реквизиты, Движения, Отказ) Экспорт

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка"				,Реквизиты.Регистратор);
	Запрос.УстановитьПараметр("ДокументОснование"	,Реквизиты.ДокументОснование);
	Запрос.УстановитьПараметр("ВалютныеОперации"	,ВалютныеОперации);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВалютныеОперации.ПаспортСделки,
		|	ВалютныеОперации.Документ,
		|	ВалютныеОперации.Сумма,
		|	ВалютныеОперации.ДатаОперации
		|ПОМЕСТИТЬ ВТ_ВалютныеОперации
		|ИЗ
		|	&ВалютныеОперации КАК ВалютныеОперации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеПоПаспортуСделкиОбороты.ПаспортСделки КАК ПаспортСделки,
		|	ДанныеПоПаспортуСделкиОбороты.УчетныйДокумент,
		|	-ДанныеПоПаспортуСделкиОбороты.СуммаВалютнаяОперацияОборот КАК СуммаВалютнаяОперация,
		|	-ДанныеПоПаспортуСделкиОбороты.СуммаПодтверждающийДокументОборот КАК СуммаПодтверждающийДокумент,
		|	ДанныеПоПаспортуСделкиОбороты.Период КАК Период,
		|	ЛОЖЬ КАК Активность
		|ИЗ
		|	РегистрНакопления.бит_ДанныеПоПаспортамСделок.Обороты(, , Запись, ) КАК ДанныеПоПаспортуСделкиОбороты
		|ГДЕ
		|	ДанныеПоПаспортуСделкиОбороты.Регистратор = &ДокументОснование
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТ_ВалютныеОперации.ПаспортСделки,
		|	ВТ_ВалютныеОперации.Документ,
		|	СУММА(ВТ_ВалютныеОперации.Сумма),
		|	0,
		|	ВТ_ВалютныеОперации.ДатаОперации,
		|	ЛОЖЬ
		|ИЗ
		|	ВТ_ВалютныеОперации КАК ВТ_ВалютныеОперации
		|ГДЕ
		|	ВТ_ВалютныеОперации.ПаспортСделки <> ЗНАЧЕНИЕ(Справочник.бит_ПаспортаСделок.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ВалютныеОперации.ПаспортСделки,
		|	ВТ_ВалютныеОперации.ДатаОперации,
		|	ВТ_ВалютныеОперации.Документ";
	
	ТаблицаДвижений = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаДвижений.Количество() > 0 Тогда
	
		Движения.бит_ДанныеПоПаспортамСделок.Записывать = Истина;
		Движения.бит_ДанныеПоПаспортамСделок.мТаблицаДвижений = ТаблицаДвижений;
		Движения.бит_ДанныеПоПаспортамСделок.ДобавитьДвижение();
		
	КонецЕсли;	
	
КонецПроцедуры

// Функция возвращает параметры выбора кода из макета.
// 
// Параметры:
//  НазваниеМакета 	- Строка
//  ТекущийПериод 	- Дата
// 
// Возвращаемое значение:
//  Параметры - Структура
// 
Функция ПолучитьПараметрыФормыВыбораДляКода(НаименованиеМакета, ТекущийПериод) Экспорт
	
	Классификатор = Новый ТаблицаЗначений;
	
	Классификатор.Колонки.Добавить("Код");
	Классификатор.Колонки.Добавить("Наименование");
	Классификатор.Индексы.Добавить("Код");
	
	Макет	= ПолучитьМакет(НаименованиеМакета);
	
	ТекущаяОбласть = Макет.Области.Найти("Классификатор");
	
	Если НЕ ТекущаяОбласть = Неопределено Тогда
		
		Для НомерСтр = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
			
			КодПоказателя	= СокрП(Макет.Область(НомерСтр, 1).Текст);
			Название		= СокрП(Макет.Область(НомерСтр, 2).Текст);
			
			Если КодПоказателя = "###" Тогда
				Прервать;
			ИначеЕсли ПустаяСтрока(КодПоказателя) Тогда
				Продолжить;
			Иначе
				НоваяСтрока = Классификатор.Добавить();
				НоваяСтрока.Код				= КодПоказателя;
				НоваяСтрока.Наименование	= Название;
			КонецЕсли;	
				
		КонецЦикла;
		
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("СписокКодов",	Классификатор);
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция формирует печатную форму справки о валютных операциях.
// 
// Параметры:
//  МассивСсылок 		   	  - Массив.
// 
// Возвращаемое значение:
//  ТабличныйДокумент - ТабличныйДокумент.
// 
Функция СформироватьПечатнуюФормуСВО(МассивСсылок)

	ТабДок = Новый ТабличныйДокумент;
	ТабДок.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_бит_СправкаОВалютныхОперациях_СправкаОВалютныхОперациях";
	
	// Формируем запрос по документу.
	Результат 	= ПолучитьРезультатЗапросаПоСправке(МассивСсылок);
	Выборка 	= Результат.Выбрать();
	
	Если НЕ Результат.Пустой() Тогда
		
		Макет = ПолучитьМакет("СправкаОВалютныхОперациях");
		
		Шапка 					= Макет.ПолучитьОбласть("Шапка");
		ОбластьВОШапка 			= Макет.ПолучитьОбласть("ВалютныеОперацииШапка");
		ОбластьВО 				= Макет.ПолучитьОбласть("ВалютныеОперации");
		ОбластьПримечаниеШапка 	= Макет.ПолучитьОбласть("ПримечаниеШапка");
		ОбластьПодвал 			= Макет.ПолучитьОбласть("Подвал");
		
		ТабДок.Очистить();

		Пока Выборка.Следующий() Цикл

			Шапка.Параметры.Заполнить(Выборка);
			Если Выборка.ПорядковыйНомерКорректировки <> 0 Тогда
				Шапка.Параметры.Корректировка = Выборка.Корректировка + " (" + Выборка.ПорядковыйНомерКорректировки + ")";
			КонецЕсли; 
			ТабДок.Вывести(Шапка, Выборка.Уровень());

			ТабДок.Вывести(ОбластьВОШапка);
			
			ОбластиПримечание = Новый Массив;
			
			ВыборкаТабДок = Выборка.ВалютныеОперации.Выбрать();
			Пока ВыборкаТабДок.Следующий() Цикл
				ОбластьВО.Параметры.Заполнить(ВыборкаТабДок);
				
				ОбластьВО.Параметры.НомерДокумента = ВыборкаТабДок.НомерДокумента + " / " + Формат(ВыборкаТабДок.ДатаДокумента, "ДФ=dd.MM.yyyy");
				
				Если НЕ ЗначениеЗаполнено(ВыборкаТабДок.ПаспортСделки) Тогда
					НомерПС = ?(ЗначениеЗаполнено(ВыборкаТабДок.НомерДоговораКонтрагента),
						ВыборкаТабДок.НомерДоговораКонтрагента, "БН");
					Если ЗначениеЗаполнено(ВыборкаТабДок.ДатаДоговораКонтрагента) Тогда
						НомерПС = НомерПС + " / " + Формат(ВыборкаТабДок.ДатаДоговораКонтрагента, "ДФ=dd.MM.yyyy");
					КонецЕсли;
					
					ОбластьВО.Параметры.ПаспортСделки = НомерПС;
					
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(ВыборкаТабДок.Примечание) Тогда
					ОбластьПримечание = Макет.ПолучитьОбласть("Примечание");
					ОбластьПримечание.Параметры.Заполнить(ВыборкаТабДок);
					ОбластиПримечание.Добавить(ОбластьПримечание);
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьВО, ВыборкаТабДок.Уровень());
				
			КонецЦикла;
			
			ТабДок.Вывести(ОбластьПримечаниеШапка);
			
			Для Каждого ТекОбласть Из ОбластиПримечание Цикл
				ТабДок.Вывести(ТекОбласть)
			КонецЦикла;
			
			ТабДок.Вывести(ОбластьПодвал);
			
		КонецЦикла;
	КонецЕсли;	
		
	Возврат ТабДок;
			
КонецФункции

// Функция получает результат запроса по массиву документов.
// 
// Параметры:
//  МассивСсылок - Массив
// 
// Возвращаемое значение:
//  Результат - ТаблицаЗначений.
// 
Функция ПолучитьРезультатЗапросаПоСправке(МассивСсылок)

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Документ.Банк КАК Банк,
	               |	Документ.БанковскийСчет.НомерСчета КАК БанковскийСчет,
	               |	Документ.ДатаЗаполнения КАК ДатаЗаполнения,
	               |	ВЫБОР
	               |		КОГДА Документ.Корректировка = ИСТИНА
	               |			ТОГДА ""*""
	               |		ИНАЧЕ """"
	               |	КОНЕЦ КАК Корректировка,
	               |	Документ.Организация.НаименованиеСокращенное КАК Организация,
	               |	Документ.СтранаБанкаНерезидента.Код КАК СтранаБанкаНерезидентаКод,
	               |	Документ.ВалютныеОперации.(
	               |		НомерСтроки КАК НомерСтроки,
	               |		Корректировка КАК Корректировка,
	               |		Документ КАК Документ,
	               |		ВЫБОР
	               |			КОГДА Документ.ВалютныеОперации.НомерДокумента = """"
	               |				ТОГДА ""БН""
	               |			ИНАЧЕ Документ.ВалютныеОперации.НомерДокумента
	               |		КОНЕЦ КАК НомерДокумента,
	               |		ДатаДокумента КАК ДатаДокумента,
	               |		ДатаОперации КАК ДатаОперации,
	               |		ПризнакПлатежа КАК ПризнакПлатежа,
	               |		ВидВалютнойОперации КАК ВидВалютнойОперации,
	               |		ВалютаОперации.Код КАК ВалютаОперацииКод,
	               |		Сумма КАК Сумма,
	               |		ПаспортСделки.Код КАК ПаспортСделки,
	               |		ВЫБОР
	               |			КОГДА Документ.ВалютныеОперации.ВалютаДоговора = Документ.ВалютныеОперации.ВалютаОперации
	               |				ТОГДА """"
	               |			ИНАЧЕ Документ.ВалютныеОперации.ВалютаДоговора.Код
	               |		КОНЕЦ КАК ВалютаДоговораКод,
	               |		ВЫБОР
	               |			КОГДА Документ.ВалютныеОперации.ВалютаДоговора = Документ.ВалютныеОперации.ВалютаОперации
	               |				ТОГДА """"
	               |			ИНАЧЕ Документ.ВалютныеОперации.СуммаВВалютеДоговора
	               |		КОНЕЦ КАК СуммаВВалютеДоговора,
	               |		ОжидаемыйСрок КАК ОжидаемыйСрок,
	               |		Примечание КАК Примечание,
	               |		ДоговорКонтрагента.Номер КАК НомерДоговораКонтрагента,
	               |		ДоговорКонтрагента.Дата КАК ДатаДоговораКонтрагента,
	               |		СрокВозвратаАванса КАК СрокВозвратаАванса
	               |	) КАК ВалютныеОперации,
	               |	Документ.ПорядковыйНомерКорректировки КАК ПорядковыйНомерКорректировки
	               |ИЗ
	               |	Документ.бит_СправкаОВалютныхОперациях КАК Документ
	               |ГДЕ
	               |	Документ.Ссылка В(&МассивСсылок)";
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат;
	
КонецФункции

Функция ТекстЗапросаРеквизиты(НомераТаблиц)

	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Реквизиты.Ссылка КАК Регистратор,
		|	Реквизиты.Дата,
		|	Реквизиты.ДатаЗаполнения,
		|	Реквизиты.Банк,
		|	Реквизиты.Организация,
		|	Реквизиты.ДокументОснование,
		|	Реквизиты.БанковскийСчет
		|ИЗ
		|	Документ.бит_СправкаОВалютныхОперациях КАК Реквизиты
		|ГДЕ
		|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + бит_ОбщегоНазначения.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаВалютныеОперации(НомераТаблиц)

	НомераТаблиц.Вставить("ВалютныеОперации", НомераТаблиц.Количество());
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ВалютныеОперации.Ссылка,
		|	ВалютныеОперации.ДатаДокумента,
		|	ВалютныеОперации.ДатаОперации,
		|	ВалютныеОперации.ПризнакПлатежа,
		|	ВалютныеОперации.Сумма,
		|	ВалютныеОперации.ПаспортСделки,
		|	ВалютныеОперации.Документ
		|ИЗ
		|	Документ.бит_СправкаОВалютныхОперациях.ВалютныеОперации КАК ВалютныеОперации
		|ГДЕ
		|	ВалютныеОперации.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + бит_ОбщегоНазначения.ТекстРазделителяЗапросовПакета();

КонецФункции

#КонецОбласти

#КонецЕсли

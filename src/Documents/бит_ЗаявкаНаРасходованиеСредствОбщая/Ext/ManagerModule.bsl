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
	
    // Заявка на оплату.
    КомандаПечати = КомандыПечати.Добавить();
    КомандаПечати.Идентификатор = "ЗаявкаНаОплату";
    КомандаПечати.Представление = НСтр("ru = 'Заявка на оплату'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок       = 10;
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявкаНаОплату") Тогда					
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ЗаявкаНаОплату", НСтр("ru = 'Заявка на оплату'"), 
			СформироватьПечатнуюФормуЗаявкиНаОплату(МассивОбъектов),,"Документ.бит_ЗаявкаНаРасходованиеСредствОбщая.ЗаявкаНаОплату");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПеренестиНазначениеПлатежаПриПереходеНаНовуюВерсию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.бит_ЗаявкаНаРасходованиеСредствОбщая КАК бит_ЗаявкаНаРасходованиеСредствОбщая";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ТекущийОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ТекущийОбъект.НазначениеПлатежаУпр = ТекущийОбъект.УдалитьНазначениеПлатежаУпр;   
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ТекущийОбъект);
		
	КонецЦикла;	

КонецПроцедуры

Функция НовыеРеквизитыДляСинхронизации() Экспорт
	
	НовыеРеквизиты = Новый Структура;
	НовыеРеквизиты.Вставить("ЦФО", 					"ЦФО");
	НовыеРеквизиты.Вставить("СтатьяОборотов", 		"СтатьяОборотов");
	НовыеРеквизиты.Вставить("Проект", 				"Проект");
	НовыеРеквизиты.Вставить("ДоговорКонтрагента", 	"ДоговорКонтрагента");
	НовыеРеквизиты.Вставить("Сумма", 				"Сумма");
	НовыеРеквизиты.Вставить("СтавкаНДС", 			"СтавкаНДС");
	НовыеРеквизиты.Вставить("НДС", 					"НДС");
	НовыеРеквизиты.Вставить("НоменклатурнаяГруппа", "НоменклатурнаяГруппа");
	
	МаксКолвоДопАналитик = бит_МеханизмДопИзмерений.ПолучитьМаксимальноеКоличествоДополнительныхИзмерений();
	Для Индекс = 1 По МаксКолвоДопАналитик Цикл
		НовыеРеквизиты.Вставить("Аналитика_" + Индекс, "Аналитика_" + Индекс);
	КонецЦикла;   	

	Возврат НовыеРеквизиты;
	
КонецФункции
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция формирует печатную форму заявки на оплату.
// 
// Параметры:
//  МассивСсылок - Массив.
// 
// Возвращаемое значение:
//  ТабличныйДокумент - ТабличныйДокумент.
// 
Функция СформироватьПечатнуюФормуЗаявкиНаОплату(МассивСсылок)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_бит_ЗаявкаНаРасходованиеСредствОбщая_ЗаявкаНаОплату";
	
	// Формируем запрос по заявке.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);

	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Ссылка,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Номер,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Дата КАК ДатаДок,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Организация КАК Плательщик,
	|	ВЫБОР
	|		КОГДА бит_ЗаявкаНаРасходованиеСредствОбщая.ТипЗаявки = ЗНАЧЕНИЕ(Перечисление.бит_ТипыЗаявокНаРасходованиеСредств.Плановая)
	|			ТОГДА ""Плановый""
	|		КОГДА бит_ЗаявкаНаРасходованиеСредствОбщая.ТипЗаявки = ЗНАЧЕНИЕ(Перечисление.бит_ТипыЗаявокНаРасходованиеСредств.ВнеПлановая)
	|			ТОГДА ""Внеплановый""
	|		ИНАЧЕ бит_ЗаявкаНаРасходованиеСредствОбщая.ТипЗаявки
	|	КОНЕЦ КАК ТипЗаявки,
	|	ВЫБОР
	|		КОГДА бит_ЗаявкаНаРасходованиеСредствОбщая.ЭтоКазначейство
	|			ТОГДА "" / Казначейская""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Казначейство,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.ФормаОплаты,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.ДатаРасхода,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.ВалютаДокумента,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Сумма,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.НДС КАК СуммаНДС,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.СтатьяОборотов,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Проект,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.НазначениеПлатежа,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Ответственный КАК СтрокаОтветственный,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Комментарий,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.СтатьяОборотов.Код КАК СтатьяОборотовКод,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.СтатьяОборотов.Родитель КАК СтатьяРодитель,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.СтатьяОборотов.Родитель.Код КАК СтатьяРодительКод,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Проект.Код КАК ПроектКод,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.ЦФО КАК Подразделение,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Контрагент,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.ДоговорКонтрагента КАК Договор,
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.ДоговорКонтрагента.Код КАК ДоговорКод
	|ИЗ
	|	Документ.бит_ЗаявкаНаРасходованиеСредствОбщая КАК бит_ЗаявкаНаРасходованиеСредствОбщая
	|ГДЕ
	|	бит_ЗаявкаНаРасходованиеСредствОбщая.Ссылка В(&МассивСсылок)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		// Получим таблицу установленных виз.
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	бит_УстановленныеВизы.Объект КАК Ссылка,
		|	бит_УстановленныеВизы.Виза,
		|	бит_УстановленныеВизы.ФизическоеЛицо КАК ФИО
		|ИЗ
		|	РегистрСведений.бит_УстановленныеВизы КАК бит_УстановленныеВизы
		|ГДЕ
		|	бит_УстановленныеВизы.Объект В(&МассивСсылок)
		|
		|УПОРЯДОЧИТЬ ПО
		|	бит_УстановленныеВизы.КодСортировки";
		
		ТаблицаПоВизам = Запрос.Выполнить().Выгрузить();
		
		// Получаем макет.
		Макет = ПолучитьМакет("ЗаявкаНаОплату");
		
		// Получаем области.
		Заявка 	   = Макет.ПолучитьОбласть("Заявка");
		Договор	   = Макет.ПолучитьОбласть("Договор");
		ШапкаВиза  = Макет.ПолучитьОбласть("ШапкаВиза");
		СтрокаВиза = Макет.ПолучитьОбласть("СтрокаВиза");
		ЗаявкаНиз  = Макет.ПолучитьОбласть("ЗаявкаНиз");
		
		ПервыйДокумент   = Истина;
		ВыборкаИзЗапроса = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаИзЗапроса.Следующий() Цикл 
			
			ТекДокумент = ВыборкаИзЗапроса.Ссылка;
			
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ПервыйДокумент = Ложь;
			
			// Заполяем параметры областей.
			Заявка.Параметры.Заполнить(ВыборкаИзЗапроса);			   
			
			ЗаявкаЗаголовок = "ПРОГНОЗ ПЛАТЕЖА" 
							  + ?(ВыборкаИзЗапроса.ФормаОплаты = Перечисления.бит_ВидыДенежныхСредств.Наличные, " НАЛИЧНЫХ ", " БЕЗНАЛИЧНЫХ ") 
							  + "ДЕНЕЖНЫХ СРЕДСТВ от";
			
			СуммаДокумента = ?(ЗначениеЗаполнено(ВыборкаИзЗапроса.Сумма), ВыборкаИзЗапроса.Сумма, 0);
			
			Заявка.Параметры.Заголовок 	   = ЗаявкаЗаголовок;
			Заявка.Параметры.НомерДок 	   = бит_ОбщегоНазначенияКлиентСервер.ПолучитьНомерНаПечать(ТекДокумент);
			Заявка.Параметры.СуммаПрописью = бит_ФормированиеПечатныхФорм.СформироватьСуммуПрописью(СуммаДокумента, ВыборкаИзЗапроса.ВалютаДокумента);
			
			// Выводим область "Заявка" в табличный документ.
			ТабличныйДокумент.Вывести(Заявка);
			
			Если ЗначениеЗаполнено(ВыборкаИзЗапроса.Договор) Тогда
			
				// Выводим область "Договор" в табличный документ.
				Договор.Параметры.Заполнить(ВыборкаИзЗапроса);	
				ТабличныйДокумент.Вывести(Договор);
			
			КонецЕсли; 
			
			ТабличныйДокумент.Вывести(ШапкаВиза);
			
			ЗаявкаНиз.Параметры.Заполнить(ВыборкаИзЗапроса);
			
			// Получим список виз для текущего документа.
			Отбор = Новый Структура;
			Отбор.Вставить("Ссылка", ТекДокумент);
			
			МассивСтрок = ТаблицаПоВизам.НайтиСтроки(Отбор);
			
			// Заполняем и выводим в табличный документ строки с визами.
			Для Каждого ТекСтрока Из МассивСтрок Цикл
				
				СтрокаВиза.Параметры.Заполнить(ТекСтрока);
				ТабличныйДокумент.Вывести(СтрокаВиза);
				
			КонецЦикла;	
			
			// Выводим область "ЗаявкаНиз" в табличный документ.
			ТабличныйДокумент.Вывести(ЗаявкаНиз);
			
		КонецЦикла; // Пока ВыборкаИзЗапроса.Следующий() Цикл
		
	КонецЕсли; // Если Не РезультатЗапроса.Пустой() Тогда
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли

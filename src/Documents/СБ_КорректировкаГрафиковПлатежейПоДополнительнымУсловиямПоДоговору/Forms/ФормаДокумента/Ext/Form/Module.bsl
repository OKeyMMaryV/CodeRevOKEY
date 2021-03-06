&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	Если ЗначениеЗаполнено(Объект.Организация) Тогда 
		
		ЗаполнениеДокументов.ПриИзмененииЗначенияОрганизации(Объект, Пользователи.ТекущийПользователь());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаполнитьФинансовыйГрафик" Тогда
		ЗаполнитьФинансовыйГрафикНаСервере(Параметр);
	Иначе
		ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьФинансовыйГрафикНаСервере(Параметр)
	
	ТаблицаПлатежей = бит_ОбщегоНазначения.РаспаковатьТаблицуИзМассива(Параметр.СтруктураТаблиц.ГрафикПлатежей,Параметр.СтруктураТаблиц.ГрафикПлатежей_Колонки);

	Если Параметр.РежимДобавления = "Загрузить" Тогда
		
		Объект.ТаблицаКорректировки.Очистить();
		
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	бит_ДополнительныеУсловияПоДоговору.Ссылка,
	               |	бит_ДополнительныеУсловияПоДоговору.ЦФО,
	               |	бит_ДополнительныеУсловияПоДоговору.Сценарий
	               |ИЗ
	               |	Документ.бит_ДополнительныеУсловияПоДоговору КАК бит_ДополнительныеУсловияПоДоговору
	               |ГДЕ
	               |	бит_ДополнительныеУсловияПоДоговору.ДоговорКонтрагента = &ДоговорКонтрагента
	               |	И бит_ДополнительныеУсловияПоДоговору.Проведен
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	бит_ДополнительныеУсловияПоДоговору.Дата УБЫВ"; 
	Запрос.УстановитьПараметр("ДоговорКонтрагента", Объект.ДоговорКонтрагента);			   
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();

	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПлатежей.Период,
	|	ТаблицаПлатежей.СтатьяОборотов,
	|	ТаблицаПлатежей.СоставляющаяПлатежа,
	|	ТаблицаПлатежей.Сумма
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	&ТаблицаПлатежей КАК ТаблицаПлатежей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТРасход.Период,
	|	ВТРасход.СтатьяОборотов,
	|	ВТРасход.СоставляющаяПлатежа,
	|	СУММА(-ВТРасход.Сумма) КАК СуммаСтарая,
	|	СУММА(0) КАК СуммаНовая
	|ПОМЕСТИТЬ ВТ_Объединение
	|ИЗ
	|	ВТ КАК ВТРасход
	|ГДЕ
	|	ВТРасход.Сумма < 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТРасход.Период,
	|	ВТРасход.СоставляющаяПлатежа,
	|	ВТРасход.СтатьяОборотов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТПриход.Период,
	|	ВТПриход.СтатьяОборотов,
	|	ВТПриход.СоставляющаяПлатежа,
	|	СУММА(0),
	|	СУММА(ВТПриход.Сумма)
	|ИЗ
	|	ВТ КАК ВТПриход
	|ГДЕ
	|	ВТПриход.Сумма >= 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТПриход.Период,
	|	ВТПриход.СтатьяОборотов,
	|	ВТПриход.СоставляющаяПлатежа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Объединение.Период,
	|	ВТ_Объединение.СтатьяОборотов,
	|	ВТ_Объединение.СоставляющаяПлатежа,
	|	СУММА(ВТ_Объединение.СуммаСтарая) КАК СуммаСтарая,
	|	СУММА(ВТ_Объединение.СуммаНовая) КАК СуммаНовая
	|ИЗ
	|	ВТ_Объединение КАК ВТ_Объединение
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Объединение.Период,
	|	ВТ_Объединение.СоставляющаяПлатежа,
	|	ВТ_Объединение.СтатьяОборотов";
	Запрос.Текст = ТекстЗапроса; 
	Запрос.УстановитьПараметр("ТаблицаПлатежей", ТаблицаПлатежей);
	ТаблицаСумм = Запрос.Выполнить().Выгрузить();

	СтруктураПоиска = Новый Структура("Период, СоставляющаяПлатежа");

	СуммаДолгаСтарая = 0;

	Для Каждого ТекущаяСтрока Из ТаблицаСумм Цикл
		
		НоваяСтрока = Объект.ТаблицаКорректировки.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
		
		НоваяСтрока.ЦФО = Выборка.ЦФО;
		НоваяСтрока.Сценарий = Выборка.Сценарий;
		
		Если ТекущаяСтрока.СоставляющаяПлатежа = Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.ПогашениеОсновногоДолга Тогда
			СуммаДолгаСтарая = СуммаДолгаСтарая + НоваяСтрока.СуммаСтарая;
		КонецЕсли;
		
	КонецЦикла;

	СуммаЗадолженностиПоГрафику = СуммаДолгаСтарая;

КонецФункции

&НаКлиенте
Процедура СоздатьФинансовыйГрафик(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		ТекстСообщения = НСтр("ru='Перед созданием финансового графика документ необходимо записать!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если Объект.Проведен Тогда
		ТекстСообщения = НСтр("ru='Формирование финансового графика может быть произведено только в непроведенном документе!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	// 1c-izhtc, ChuckNorris, 21.08.2015 ( 
	Док = ПолучитьДополнительныеУсловияПоДоговору(Объект.ДоговорКонтрагента);
	Если Док = Неопределено  Тогда
		ТекстСообщения = НСтр("ru='По данному договору отсутствуют документы ""Дополнительные условия по договору""!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);		
		Возврат;
	КонецЕсли; 
	// 1c-izhtc, ChuckNorris, 21.08.2015 ) 
	
	ПараметрыФормы = ПолучитьПараметрыФормы(Объект.ДоговорКонтрагента, Объект.Дата, Объект.СуммаЗадолженностиНовая, Док);
	ОткрытьФорму("Обработка.бит_ФормированиеГрафиковПлатежейПоФинансовымДоговорам.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДополнительныеУсловияПоДоговору(ДоговорКонтрагента)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	бит_ДополнительныеУсловияПоДоговору.Ссылка
	               |ИЗ
	               |	Документ.бит_ДополнительныеУсловияПоДоговору КАК бит_ДополнительныеУсловияПоДоговору
	               |ГДЕ
	               |	бит_ДополнительныеУсловияПоДоговору.ДоговорКонтрагента = &ДоговорКонтрагента
	               |	И бит_ДополнительныеУсловияПоДоговору.Проведен
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	бит_ДополнительныеУсловияПоДоговору.Дата УБЫВ"; 
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);			   
	РезультатЗапроса = Запрос.Выполнить();
		
	Если РезультатЗапроса.Пустой() Тогда Возврат Неопределено; КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
		
	Возврат Выборка.Ссылка;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПараметрыФормы(ДоговорКонтрагента, Дата, СуммаЗадолженностиНовая, Док)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_ДополнительныеУсловияПоДоговоруГрафикВыдачиТраншей.ДатаТранша,
	               |	бит_ДополнительныеУсловияПоДоговоруГрафикВыдачиТраншей.ДатаПогашения,
	               |	бит_ДополнительныеУсловияПоДоговоруГрафикВыдачиТраншей.СуммаТранша,
	               |	бит_ДополнительныеУсловияПоДоговоруГрафикВыдачиТраншей.МесяцПервогоПлатежа,
	               |	бит_ДополнительныеУсловияПоДоговоруГрафикВыдачиТраншей.ПредставлениеМесяцаПервогоПлатежа,
	               |	бит_ДополнительныеУсловияПоДоговоруГрафикВыдачиТраншей.КоличествоПериодовВыплат,
	               |	бит_ДополнительныеУсловияПоДоговоруГрафикВыдачиТраншей.СБ_ПроцентнаяСтавкаПоТраншу
	               |ИЗ
	               |	Документ.бит_ДополнительныеУсловияПоДоговору.ГрафикВыдачиТраншей КАК бит_ДополнительныеУсловияПоДоговоруГрафикВыдачиТраншей
	               |ГДЕ
	               |	бит_ДополнительныеУсловияПоДоговоруГрафикВыдачиТраншей.Ссылка = &Ссылка";
				   
	Запрос.УстановитьПараметр("Ссылка", Док);			   
	ГрафикТраншей = Запрос.Выполнить().Выгрузить();
	
	СтруктураТаблиц = Новый Структура;
	УпаковатьТаблицу(СтруктураТаблиц, ГрафикТраншей, "ГрафикВыдачиТраншей");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДоговорКонтрагента"	, ДоговорКонтрагента);
	ПараметрыФормы.Вставить("НаправлениеДДС"		, "Получение");
	ПараметрыФормы.Вставить("ВидГрафика"			, Перечисления.бит_ТипыСтатейОборотов.БДДС);
	ПараметрыФормы.Вставить("Документ"				, Док);
	ПараметрыФормы.Вставить("СтруктураТаблиц"		, СтруктураТаблиц);
	ПараметрыФормы.Вставить("КорректировкаГрафика"	, Истина);
	ПараметрыФормы.Вставить("СуммаКорректировки"	, СуммаЗадолженностиНовая);
	ПараметрыФормы.Вставить("ДатаНачалаРасчета"		, НачалоДня(Дата) + 86400);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УпаковатьТаблицу(СтрТаблиц, Таблица, ИмяТаблицы)
	
	МассивРеквизитов = Таблица.Колонки;
	ИменаРеквизитов  = Новый Структура;
	Для каждого Реквизит ИЗ МассивРеквизитов Цикл
		
		ИменаРеквизитов.Вставить(Реквизит.Имя,Реквизит.ТипЗначения);
		
	КонецЦикла;
	СтрТаблиц.Вставить(ИмяТаблицы, бит_ОбщегоНазначенияКлиентСервер.УпаковатьДанныеФормыКоллекция(Таблица,ИменаРеквизитов));
	СтрТаблиц.Вставить(ИмяТаблицы+"_Колонки", ИменаРеквизитов);
	
КонецПроцедуры

// 1c-izhtc, ChuckNorris, 20.08.2015 ( 
&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьСостояниеДокумента();
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// 1c-izhtc, ChuckNorris, 24.08.2015 ( 
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	// 1c-izhtc, ChuckNorris, 24.08.2015 ) 
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьСостояниеДокумента();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры
// 1c-izhtc, ChuckNorris, 20.08.2015 ) 
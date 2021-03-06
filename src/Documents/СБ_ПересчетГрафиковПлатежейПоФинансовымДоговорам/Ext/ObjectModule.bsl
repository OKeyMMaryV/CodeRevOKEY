Процедура ПодготовитьТаблицыДокумента(ТаблицаПоПереоценке, ТаблицаПоПересчету) Экспорт
	
	// Получим необходимые данные для проведения и проверки заполенения данные по табличной части "ПереоценкаВалютныхСумм".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Контрагент"       		, "Контрагент");
	СтруктураПолей.Вставить("ДоговорКонтрагента"	, "ДоговорКонтрагента");
	СтруктураПолей.Вставить("ДокументРегистратор"	, "Документ");
	СтруктураПолей.Вставить("Период" 		    	, "ПериодПлатежа");
	СтруктураПолей.Вставить("Сценарий"          	, "Сценарий");
	СтруктураПолей.Вставить("ВалютаСценария"      	, "Сценарий.Валюта");
	СтруктураПолей.Вставить("ЦФО"  					, "ЦФО");
	СтруктураПолей.Вставить("СтатьяОборотов"    	, "СтатьяОборотов");
	СтруктураПолей.Вставить("СтавкаНДС"    			, "СтатьяОборотов.СтавкаНДС");
	СтруктураПолей.Вставить("ТипСтатьи"		   	 	, "СтатьяОборотов.ТипСтатьи");
	СтруктураПолей.Вставить("СоставляющаяПлатежа"   , "СоставляющаяПлатежа");
	СтруктураПолей.Вставить("СБ_ДатаДокумента" 		, "Ссылка.Дата");
	СтруктураПолей.Вставить("СуммаУпр"   			, "СуммаПереоценки");

	РезультатЗапросаПоПереоценке = УчетОС.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ПереоценкаВалютныхСумм", СтруктураПолей);

	// Получим необходимые данные для проведения и проверки заполенения данные по табличной части "ПересчетПроцентовПоПлавающимСтавкам".
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.Контрагент КАК Контрагент,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.ДоговорКонтрагента КАК ДоговорКонтрагента,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.ДокументДопУсловий КАК ДокументРегистратор,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.ПериодПлатежа КАК Период,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.Сценарий КАК Сценарий,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.Сценарий.Валюта КАК ВалютаСценария,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.ЦФО КАК ЦФО,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.СтатьяОборотов КАК СтатьяОборотов,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.СтатьяОборотов.ТипСтатьи КАК ТипСтатьи,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.СоставляющаяПлатежа КАК СоставляющаяПлатежа,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.Ссылка.Дата КАК СБ_ДатаДокумента,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.Дельта КАК СуммаСценарий,
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.СтатьяОборотов.СтавкаНДС КАК СтавкаНДС
	               |ИЗ
	               |	Документ.СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорам.ПересчетПроцентовПоПлавающимСтавкам КАК СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам
	               |ГДЕ
	               |	СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.СоставляющаяПлатежа = ЗНАЧЕНИЕ(Справочник.бит_СоставляющиеПлатежейПоФинДоговорам.Проценты)
	               |	И СБ_ПересчетГрафиковПлатежейПоФинансовымДоговорамПересчетПроцентовПоПлавающимСтавкам.Ссылка = &Ссылка"; 
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
				   
	РезультатЗапросаПоПересчету = Запрос.Выполнить();

	// Подготовим таблицу товаров для проведения.
	ТаблицаПоПереоценке = РезультатЗапросаПоПереоценке.Выгрузить();
	ТаблицаПоПересчету  = РезультатЗапросаПоПересчету.Выгрузить();
	
КонецПроцедуры // ПодготовитьТаблицыДокумента()

Процедура ДвиженияПоРегистрам(РежимПроведения, ТаблицаПоПереоценке, ТаблицаПоПересчету, Отказ);

	ГрафикиДоговоров = Движения.бит_ГрафикиДоговоров;
	ГрафикиДоговоров.Записывать = Истина;
	
	// Получим курсы валют, неоходимые для выполнения пересчетов.
	ВидыКурсов = Новый Структура("Регл, Упр");
	СтруктураКурсыВалют = бит_му_ОбщегоНазначения.ПолучитьСтруктуруКурсовВалют(ЭтотОбъект, Дата, ВидыКурсов);
	
	Для Каждого СтрокаТаблицы Из ТаблицаПоПереоценке Цикл
		
		Если СтрокаТаблицы.СуммаУпр = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ГрафикиДоговоров.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		
		СуммаНДСУпр = УчетНДСКлиентСервер.РассчитатьСуммуНДС(НоваяСтрока.СуммаУпр,
        											   Истина,
        											   УчетНДСПереопределяемый.ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС));
													   
		НоваяСтрока.СуммаБезНДСУпр = НоваяСтрока.СуммаУпр - СуммаНДСУпр;
		
		НоваяСтрока.СуммаРегл = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаУпр
																		  ,СтруктураКурсыВалют.Упр.Валюта
																		  ,СтруктураКурсыВалют.Регл.Валюта
																		  ,СтруктураКурсыВалют.Упр.Курс
																		  ,СтруктураКурсыВалют.Регл.Курс
																		  ,СтруктураКурсыВалют.Упр.Кратность
																		  ,СтруктураКурсыВалют.Регл.Кратность);
		
		НоваяСтрока.СуммаБезНДСРегл = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаБезНДСУпр
																		  ,СтруктураКурсыВалют.Упр.Валюта
																		  ,СтруктураКурсыВалют.Регл.Валюта
																		  ,СтруктураКурсыВалют.Упр.Курс
																		  ,СтруктураКурсыВалют.Регл.Курс
																		  ,СтруктураКурсыВалют.Упр.Кратность
																		  ,СтруктураКурсыВалют.Регл.Кратность);
																		  
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из ТаблицаПоПересчету Цикл
		
		Если СтрокаТаблицы.СуммаСценарий = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ГрафикиДоговоров.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		
		СтрКурса = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", СтрокаТаблицы.ВалютаСценария)); // 1c-izhtc, ChuckNorris, 21.08.2015
		
		СуммаНДССценарий = УчетНДСКлиентСервер.РассчитатьСуммуНДС(НоваяСтрока.СуммаСценарий,
        											   Истина,
        											   УчетНДСПереопределяемый.ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС));
													   
		НоваяСтрока.СуммаБезНДССценарий = НоваяСтрока.СуммаСценарий - СуммаНДССценарий;
		
		НоваяСтрока.СуммаРегл = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаСценарий
																		  ,СтрокаТаблицы.ВалютаСценария
																		  ,СтруктураКурсыВалют.Регл.Валюта
																		  ,СтрКурса.Курс
																		  ,СтруктураКурсыВалют.Регл.Курс
																		  ,СтрКурса.Кратность
																		  ,СтруктураКурсыВалют.Регл.Кратность);
		
		НоваяСтрока.СуммаБезНДСРегл = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаБезНДССценарий
																		  ,СтрокаТаблицы.ВалютаСценария
																		  ,СтруктураКурсыВалют.Регл.Валюта
																		  ,СтрКурса.Курс
																		  ,СтруктураКурсыВалют.Регл.Курс
																		  ,СтрКурса.Кратность
																		  ,СтруктураКурсыВалют.Регл.Кратность);
																		  
		НоваяСтрока.СуммаУпр = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаСценарий
																		  ,СтрокаТаблицы.ВалютаСценария
																		  ,СтруктураКурсыВалют.Упр.Валюта
																		  ,СтрКурса.Курс
																		  ,СтруктураКурсыВалют.Упр.Курс
																		  ,СтрКурса.Кратность
																		  ,СтруктураКурсыВалют.Упр.Кратность);
		
		НоваяСтрока.СуммаБезНДСУпр = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаБезНДССценарий
																		  ,СтрокаТаблицы.ВалютаСценария
																		  ,СтруктураКурсыВалют.Упр.Валюта
																		  ,СтрКурса.Курс
																		  ,СтруктураКурсыВалют.Упр.Курс
																		  ,СтрКурса.Кратность
																		  ,СтруктураКурсыВалют.Упр.Кратность);
		
	КонецЦикла;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Перем ТаблицаПоПереоценке, ТаблицаПоПересчету;
				
	// 1c-izhtc, ChuckNorris, 25.08.2015 ( 
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда Возврат; КонецЕсли;
	// 1c-izhtc, ChuckNorris, 25.08.2015 ) 
	
    ПодготовитьТаблицыДокумента(ТаблицаПоПереоценке, ТаблицаПоПересчету);
	
	// Движения по документу
	ДвиженияПоРегистрам(РежимПроведения, ТаблицаПоПереоценке, ТаблицаПоПересчету, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры
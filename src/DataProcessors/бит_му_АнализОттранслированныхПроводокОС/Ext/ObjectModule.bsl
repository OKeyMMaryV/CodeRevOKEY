﻿Процедура ОбновитьОсновныеСредства() Экспорт
	
	ПараметрыГраницы = Новый Массив(2);
	ПараметрыГраницы[0] = КонецДня(ДатаКон);
	ПараметрыГраницы[1] = ВидГраницы.Включая;
	Граница = Новый(Тип("Граница"),ПараметрыГраницы);
	
	//Инициализируем настроеки СКД
	НастройкиКомпановщика = ПостроительОтчета.Настройки;
	ПараметрыНастройки = НастройкиКомпановщика.ПараметрыДанных;
	
	//Устанавливаем Параметры СКД
	//Параметр "Источник"
	//ПостроительОтчета.Параметры.Вставить("Источник", Справочники.бит_ОбъектыСистемы.НайтиПоКоду("000001024"));
	//ЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Источник"));
	//ЗначениеПараметра.Значение = Справочники.бит_ОбъектыСистемы.НайтиПоКоду("000001024");
	
		
	//Параметр "НачалоПериода1"
	//ПостроительОтчета.Параметры.Вставить("НачалоПериода1", ДобавитьМесяц(ДатаНач,-1));
	ЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода1"));
	ЗначениеПараметра.Значение = ДобавитьМесяц(ДатаНач,-1);
	
	//Параметр "ДатаОстатков"
	//ПостроительОтчета.Параметры.Вставить("ДатаОстатков",Граница);
	ЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаОстатков"));
	ЗначениеПараметра.Значение = КонецДня(ДатаКон);	//Граница;

	//Параметр "Период"
	ПериодСКД = Новый СтандартныйПериод;
	ПериодСКД.ДатаНачала = НачалоДня(ДатаНач);
	ПериодСКД.ДатаОкончания = КонецДня(ДатаКон);
	ЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	ЗначениеПараметра.Значение = ПериодСКД;
	
	//установлено в СКД
	//ПостроительОтчета.Параметры.Вставить("НачалоПериода", ДатаНач);
	//ПостроительОтчета.Параметры.Вставить("КонецПериода", КонецДня(ДатаКон));
	//ПостроительОтчета.Параметры.Вставить("Счет01",ПланыСчетов.Хозрасчетный.ОсновныеСредства);
	//ПостроительОтчета.Параметры.Вставить("Счет03",ПланыСчетов.Хозрасчетный.ДоходныеВложенияВ_МЦ);
	//ПостроительОтчета.Параметры.Вставить("Счет08",ПланыСчетов.Хозрасчетный.ВложенияВоВнеоборотныеАктивы);
	
	//Параметр "БылоДвижениеРСБУ"
	//ПостроительОтчета.Параметры.Вставить("БылоДвижениеРСБУ",БылоДвижениеРСБУ);
	ЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("БылоДвижениеРСБУ"));
	ЗначениеПараметра.Значение = БылоДвижениеРСБУ;
	
	//Параметр "Организация"
	//ПостроительОтчета.Параметры.Вставить("Организация",Организация);
	ЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Организация"));
	ЗначениеПараметра.Значение = Организация;
	
		
	// BIT Amerkulov 08072014 ++
	//Установлено в СКД
	//ПостроительОтчета.Параметры.Вставить("Счет111", ПланыСчетов.бит_Дополнительный_2.ОС);
	//ПостроительОтчета.Параметры.Вставить("Счет12", ПланыСчетов.бит_Дополнительный_2.НезавершенноеСтроительство);
	//ПостроительОтчета.Параметры.Вставить("Счет07",ПланыСчетов.Хозрасчетный.ОборудованиеКУстановке);
	//Параметр "СписокСчетовМСФО"
	//ПостроительОтчета.Параметры.Вставить("СписокСчетовМСФО", СписокМСФО);
	
	//СписокМСФО = Новый Массив;
	//СписокМСФО.Добавить(ПланыСчетов.бит_Дополнительный_2.ОС);
	//СписокМСФО.Добавить(ПланыСчетов.бит_Дополнительный_2.НезавершенноеСтроительство);
	//ЗначениеПараметра = ПараметаНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СписокСчетовМСФО"));
	//ЗначениеПараметра.Значение = СписокМСФО;
	// BIT Amerkulov 08072014 -- 
	
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	//получаем компоновщик макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, ПостроительОтчета.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	//Получаем процессор компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных,,,Истина);
	
	//Определим и получим результат
	ТаблицаРезультат = Новый ТаблицаЗначений;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Для Каждого Строка Из ТаблицаРезультат Цикл
		НоваяСтрока = ОсновныеСредства.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
		
КонецПроцедуры

Процедура СоздатьДокументыКомплектации() Экспорт
	
	ЗапросМассиваОС = Новый Запрос;
	ЗапросМассиваОС.Текст = "ВЫБРАТЬ
	                        |	ВнешняяТаблицаОбработки.ОсновноеСредство
	                        |ПОМЕСТИТЬ ВТВТ
	                        |ИЗ
	                        |	&ТаблицаОбработки КАК ВнешняяТаблицаОбработки
	                        |ГДЕ
	                        |	ВнешняяТаблицаОбработки.Обрабатывать = ИСТИНА
	                        |;
	                        |
	                        |////////////////////////////////////////////////////////////////////////////////
	                        |ВЫБРАТЬ
	                        |	ВТВТ.ОсновноеСредство
	                        |ИЗ
	                        |	ВТВТ КАК ВТВТ
	                        |
	                        |СГРУППИРОВАТЬ ПО
	                        |	ВТВТ.ОсновноеСредство";
							
	ЗапросМассиваОС.УстановитьПараметр("ТаблицаОбработки", ОсновныеСредства.Выгрузить());							
	ТаблицаМассиваОС= ЗапросМассиваОС.Выполнить().Выгрузить();
	МассивОС = ТаблицаМассиваОС.ВыгрузитьКолонку("ОсновноеСредство");
	
	Если МассивОС.Количество() = 0 Тогда
		//Предупреждение("Не выбрано ни одной строки", 6);
		Сообщить("Не выбрано ни одной строки",СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;
	
	Для Каждого ОС ИЗ МассивОС Цикл
		
		ОСICLL = ?(ОС.БИТ_ГруппаОСУУ = Справочники.бит_му_КлассыОсновныхСредств.ICLL, Истина, Ложь);
				
		ЗапросКСтрокамОсновногоСредства = Новый Запрос;
		ЗапросКСтрокамОсновногоСредства.Текст = "ВЫБРАТЬ
		                                        |	ВнешняяТаблицаОбработки.ОсновноеСредство,
		                                        |	ВнешняяТаблицаОбработки.СчетРСБУ,
		                                        |	ВнешняяТаблицаОбработки.СубконтоРСБУ
		                                        |ПОМЕСТИТЬ ВТВТ
		                                        |ИЗ
		                                        |	&ТаблицаОбработки КАК ВнешняяТаблицаОбработки
		                                        |ГДЕ
		                                        |	ВнешняяТаблицаОбработки.Обрабатывать = ИСТИНА
		                                        |	И ВнешняяТаблицаОбработки.ОсновноеСредство = &ОС
		                                        |;
		                                        |
		                                        |////////////////////////////////////////////////////////////////////////////////
		                                        |ВЫБРАТЬ
		                                        |	ВТВТ.ОсновноеСредство,
		                                        |	ВТВТ.СчетРСБУ,
		                                        |	ВТВТ.СубконтоРСБУ
		                                        |ИЗ
		                                        |	ВТВТ КАК ВТВТ
		                                        |
		                                        |СГРУППИРОВАТЬ ПО
		                                        |	ВТВТ.ОсновноеСредство,
		                                        |	ВТВТ.СчетРСБУ,
		                                        |	ВТВТ.СубконтоРСБУ";
							
		ЗапросКСтрокамОсновногоСредства.УстановитьПараметр("ТаблицаОбработки", ОсновныеСредства.Выгрузить());
		ЗапросКСтрокамОсновногоСредства.УстановитьПараметр("ОС", ОС);
		СтрокиСОсновнымСредством = ЗапросКСтрокамОсновногоСредства.Выполнить().Выгрузить();
		
		НовыйКомплектация = Документы.бит_му_КомплектацияОС.СоздатьДокумент();
		НовыйКомплектация.Дата = КонецДня(ДатаКон);
		НовыйКомплектация.Организация = Организация;
		Если НЕ ОСICLL Тогда
			НовыйКомплектация.ОсновноеСредство = ОС;
		Иначе
			НовыйКомплектация.ОсновноеСредствоICLL = ОС;
		КонецЕсли;
		
		Для Каждого СтрокаОС ИЗ СтрокиСОсновнымСредством Цикл
			ЗапросПоСчетуИАналитике = Новый Запрос;
			ЗапросПоСчетуИАналитике.Текст = "ВЫБРАТЬ
			                                |	ХозрасчетныйОбороты.Регистратор,
			                                |	ХозрасчетныйОбороты.Счет,
			                                |	ХозрасчетныйОбороты.СуммаОборотДт,
			                                |	ХозрасчетныйОбороты.СуммаОборотКт,
			                                |	ХозрасчетныйОбороты.Субконто1,
			                                |	ХозрасчетныйОбороты.Субконто2,
			                                |	ХозрасчетныйОбороты.Субконто3,
			                                |	ВЫБОР
			                                |		КОГДА ХозрасчетныйОбороты.СуммаОборотКт = 0
			                                |				И НЕ ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (&Счет01, &Счет03, &Счет08)
			                                |			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
			                                |		ИНАЧЕ ХозрасчетныйОбороты.КорСчет
			                                |	КОНЕЦ КАК КорСчет,
			                                |	ВЫБОР
			                                |		КОГДА ХозрасчетныйОбороты.СуммаОборотКт = 0
			                                |				И НЕ ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (&Счет01, &Счет03, &Счет08)
			                                |			ТОГДА НЕОПРЕДЕЛЕНО
			                                |		ИНАЧЕ ХозрасчетныйОбороты.КорСубконто1
			                                |	КОНЕЦ КАК КорСубконто1,
			                                |	ВЫБОР
			                                |		КОГДА ХозрасчетныйОбороты.СуммаОборотКт = 0
			                                |				И НЕ ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (&Счет01, &Счет03, &Счет08)
			                                |			ТОГДА НЕОПРЕДЕЛЕНО
			                                |		ИНАЧЕ ХозрасчетныйОбороты.КорСубконто2
			                                |	КОНЕЦ КАК КорСубконто2,
			                                |	ВЫБОР
			                                |		КОГДА ХозрасчетныйОбороты.СуммаОборотКт = 0
			                                |				И НЕ ХозрасчетныйОбороты.КорСчет В ИЕРАРХИИ (&Счет01, &Счет03, &Счет08)
			                                |			ТОГДА НЕОПРЕДЕЛЕНО
			                                |		ИНАЧЕ ХозрасчетныйОбороты.КорСубконто3
			                                |	КОНЕЦ КАК КорСубконто3
			                                |ИЗ
			                                |	РегистрБухгалтерии.Хозрасчетный.Обороты(
			                                |			&ДатаНач,
			                                |			&ДатаКон,
			                                |			Запись,
			                                |			Счет = &Счет,
			                                |			,
			                                |			Организация = &Организация
			                                |				И (Субконто1 = &Субконто
			                                |					ИЛИ Субконто2 = &Субконто
			                                |					ИЛИ Субконто3 = &Субконто),
			                                |			,
			                                |			) КАК ХозрасчетныйОбороты
			                                |ГДЕ
			                                |	НЕ(ХозрасчетныйОбороты.Счет В ИЕРАРХИИ (&Счет08)
			                                |				И ХозрасчетныйОбороты.СуммаОборотКт = 0)";
			ЗапросПоСчетуИАналитике.УстановитьПараметр("ДатаНач"    , ДобавитьМесяц(ДатаНач,-1));											
			//ЗапросПоСчетуИАналитике.УстановитьПараметр("ДатаНач"    , );											
			ЗапросПоСчетуИАналитике.УстановитьПараметр("ДатаКон"    , ДобавитьМесяц(КонецДня(ДатаКон),1));
			
			ЗапросПоСчетуИАналитике.УстановитьПараметр("Субконто"   , СтрокаОС.СубконтоРСБУ);
			ЗапросПоСчетуИАналитике.УстановитьПараметр("Счет"       , СтрокаОС.СчетРСБУ);
			ЗапросПоСчетуИАналитике.УстановитьПараметр("Организация", Организация);
			ЗапросПоСчетуИАналитике.УстановитьПараметр("Счет01",ПланыСчетов.Хозрасчетный.ОсновныеСредства);
			ЗапросПоСчетуИАналитике.УстановитьПараметр("Счет03",ПланыСчетов.Хозрасчетный.ДоходныеВложенияВ_МЦ);
			ЗапросПоСчетуИАналитике.УстановитьПараметр("Счет08",ПланыСчетов.Хозрасчетный.ВложенияВоВнеоборотныеАктивы);
			
			Выборка = ЗапросПоСчетуИАналитике.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				НоваяСтрокаКомплектации = НовыйКомплектация.ОсновныеСредства.Добавить();
				НоваяСтрокаКомплектации.ОсновноеСредство = ОС;
				НоваяСтрокаКомплектации.ДокументРСБУ = Выборка.Регистратор;
				
				Если НЕ Выборка.СуммаОборотДт = 0 Тогда
					
					НоваяСтрокаКомплектации.Сумма = Выборка.СуммаОборотДт;
					НоваяСтрокаКомплектации.СчетДтРСБУ = Выборка.Счет;
					НоваяСтрокаКомплектации.СубконтоДт1 = Выборка.Субконто1;
					НоваяСтрокаКомплектации.СубконтоДт2 = Выборка.Субконто2;
					НоваяСтрокаКомплектации.СубконтоДт3 = Выборка.Субконто3;
					НоваяСтрокаКомплектации.СчетКтРСБУ  = Выборка.КорСчет;
					НоваяСтрокаКомплектации.СубконтоКт1 = Выборка.КорСубконто1;
					НоваяСтрокаКомплектации.СубконтоКт2 = Выборка.КорСубконто2;
					НоваяСтрокаКомплектации.СубконтоКт3 = Выборка.КорСубконто3;
					
					
				ИначеЕсли НЕ Выборка.СуммаОборотКт = 0 Тогда
					
					НоваяСтрокаКомплектации.Сумма = Выборка.СуммаОборотКт;
					НоваяСтрокаКомплектации.СчетКтРСБУ  = Выборка.Счет;
					НоваяСтрокаКомплектации.СубконтоКт1 = Выборка.Субконто1;
					НоваяСтрокаКомплектации.СубконтоКт2 = Выборка.Субконто2;
					НоваяСтрокаКомплектации.СубконтоКт3 = Выборка.Субконто3;
					НоваяСтрокаКомплектации.СчетДтРСБУ  = Выборка.КорСчет;
					НоваяСтрокаКомплектации.СубконтоДт1 = Выборка.КорСубконто1;
					НоваяСтрокаКомплектации.СубконтоДт2 = Выборка.КорСубконто2;
					НоваяСтрокаКомплектации.СубконтоДт3 = Выборка.КорСубконто3;

					
				КонецЕсли;
				
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				               |	бит_му_КомплектацияОС.СоставОС
				               |ИЗ
				               |	РегистрНакопления.бит_му_КомплектацияОС КАК бит_му_КомплектацияОС
				               |ГДЕ
				               |	бит_му_КомплектацияОС.ОС = &ОС
				               |	И бит_му_КомплектацияОС.СчетРСБУ = &СчетРСБУ
				               |	И бит_му_КомплектацияОС.АналитикаРСБУ = &АналитикаРСБУ
				               |
				               |СГРУППИРОВАТЬ ПО
				               |	бит_му_КомплектацияОС.СоставОС";
				Запрос.УстановитьПараметр("ОС", СтрокаОС.ОсновноеСредство);				
				Запрос.УстановитьПараметр("СчетРСБУ", СтрокаОС.СчетРСБУ);
				Запрос.УстановитьПараметр("АналитикаРСБУ",СтрокаОС.СубконтоРСБУ);
				Таблица = Запрос.Выполнить().Выгрузить();
				Если Таблица.Количество() = 1 Тогда
					НоваяСтрокаКомплектации.СоставОСМСФОСтарый = Таблица[0].СоставОС;
				КонецЕсли;
								
				Если НоваяСтрокаКомплектации.СчетДтРСБУ = ПланыСчетов.Хозрасчетный.ОсновныеСредства
					ИЛИ НоваяСтрокаКомплектации.СчетДтРСБУ = ПланыСчетов.Хозрасчетный.ДоходныеВложенияВ_МЦ
					ИЛИ НоваяСтрокаКомплектации.СчетДтРСБУ = ПланыСчетов.Хозрасчетный.ВложенияВоВнеоборотныеАктивы
					ИЛИ НоваяСтрокаКомплектации.СчетДтРСБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ОсновныеСредства)
					ИЛИ НоваяСтрокаКомплектации.СчетДтРСБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ДоходныеВложенияВ_МЦ)
					ИЛИ НоваяСтрокаКомплектации.СчетДтРСБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ВложенияВоВнеоборотныеАктивы) Тогда
					
				НоваяСтрокаКомплектации.СоставОСМСФОНовый = Справочники.бит_му_СоставОС.ВНА_РСБУ;	
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
		НовыйКомплектация.Комментарий = "Документ создан автоматически на основании обработки ""Анализ оттранслированных ОС""";
		НовыйКомплектация.Записать(РежимЗаписиДокумента.Запись);		
		Сообщить("Создан документ №"+НовыйКомплектация.Номер);
		
	КонецЦикла;

	
КонецПроцедуры


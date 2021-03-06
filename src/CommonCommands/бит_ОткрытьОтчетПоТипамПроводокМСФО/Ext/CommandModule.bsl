
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("РегистрБухгалтерии", ПолучитьОбъектДоступаРегистрМСФО());
	
	ОткрытьФорму("Отчет.бит_ОтчетПоТипамПроводок.Форма"
                    , ПараметрыФормы
                    , ПараметрыВыполненияКоманды.Источник
                    , Истина
                    , ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьОбъектДоступаРегистрМСФО()
	
	МетаРегистрМСФО = Метаданные.РегистрыБухгалтерии.бит_Дополнительный_2;
	ОбъектРегистрМСФО = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегистрМСФО);
	
	Возврат ОбъектРегистрМСФО;
	
КонецФункции

#КонецОбласти

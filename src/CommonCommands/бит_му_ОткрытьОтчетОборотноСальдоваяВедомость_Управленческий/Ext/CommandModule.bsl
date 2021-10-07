﻿
#Область ОбработкаКоманды

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("РФ_РегистрБухгалтерии", ПолучитьОбъектДоступаРегистрМСФО());
	
	ОткрытьФорму("Отчет.бит_ОборотноСальдоваяВедомость_Управленческий.Форма"
                 , ПараметрыФормы
                 , ПараметрыВыполненияКоманды.Источник
                 , Истина
                 , ПараметрыВыполненияКоманды.Окно);
                 
КонецПроцедуры

&НаСервере
Функция ПолучитьОбъектДоступаРегистрМСФО()
	
	МетаРегистрМСФО   = Метаданные.РегистрыБухгалтерии.бит_Дополнительный_2;
	ОбъектРегистрМСФО = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегистрМСФО);
	
	Возврат ОбъектРегистрМСФО;
	
КонецФункции

#КонецОбласти